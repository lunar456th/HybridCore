`ifndef __INSTRUCTIONMEMORY_V__
`define __INSTRUCTIONMEMORY_V__

module InstructionMemory # (
	parameter DQ_WIDTH = 16,
	parameter ECC_TEST = "OFF",
	parameter nBANK_MACHS = 4,
	parameter ADDR_WIDTH = 28,
	parameter nCK_PER_CLK = 4
	)	(

	// PC, Instruction
	input wire [31:0] PC,
	output wire [31:0] instruction

	// Inouts
	inout wire [15:0] ddr3_dq,
	inout wire [1:0] ddr3_dqs_n,
	inout wire [1:0] ddr3_dqs_p,

	// Outputs
	output wire [13:0] ddr3_addr,
	output wire [2:0] ddr3_ba,
	output wire ddr3_ras_n,
	output wire ddr3_cas_n,
	output wire ddr3_we_n,
	output wire ddr3_reset_n,
	output wire [0:0] ddr3_ck_p,
	output wire [0:0] ddr3_ck_n,
	output wire [0:0] ddr3_cke,
	output wire [0:0] ddr3_cs_n,
	output wire [1:0] ddr3_dm,
	output wire [0:0] ddr3_odt,
	
	// Outputs (check using LED)
	output reg led_pass,
	output reg led_fail,
	output wire led_calib,

	// input wires
	input wire sys_clk_i
	);
	
	localparam STATE_IDLE = 3'd0;
	localparam STATE_WRITE = 3'd1;
	localparam STATE_WRITE_DONE = 3'd2;
	localparam STATE_READ = 3'd3;
	localparam STATE_READ_DONE = 3'd4;
	localparam STATE_PARK = 3'd5;

	reg [127:0] data_to_write;
	reg [127:0] data_read_from_memory;
	reg [9:0] pwr_on_rst_ctr;
	
	initial
	begin
		// [Code Area] data_to_memory
		// 00: add R8, R9, R10
		// 01: sub R8, R9, R10
		// 02: addi R10, R9, 12
		// 03: mult R0, R8, R9
		// 04: and R7, R3, R4
		// 05: ori R14, R6, 2
		// 06: lw
		// 07: add
		// 08: add	
		data_to_write[0] = { 32'h012A4020, 32'h012A4023, 32'h212A000C, 32'h01090018 };
		data_to_write[1] = { 32'h012A4024, 32'h34CE0002, 32'h8D28000C, 32'h2128000D };
		data_to_write[2] = { 32'h212B000D, 96'h0 };
		data_read_from_memory = 128'd0;
		pwr_on_rst_ctr = 1023;
	end	

	localparam DATA_WIDTH = 16;
	localparam PAYLOAD_WIDTH = (ECC_TEST == "OFF") ? DATA_WIDTH : DQ_WIDTH;
	localparam APP_DATA_WIDTH = 2 * nCK_PER_CLK * PAYLOAD_WIDTH;
	localparam APP_MASK_WIDTH = APP_DATA_WIDTH / 8;
	
	wire init_calib_complete;

	reg [ADDR_WIDTH-1:0] app_addr = 0;
	reg [2:0] app_cmd = 0;
	reg app_en;
	reg [APP_DATA_WIDTH-1:0] app_wdf_data;
	wire app_wdf_end = 1;
	wire [APP_MASK_WIDTH-1:0] app_wdf_mask = 0;
	reg app_wdf_wren;
	wire [127:0] app_rd_data;
	wire app_rd_data_end;
	wire app_rd_data_valid;
	wire app_rdy;
	wire app_wdf_rdy;
	wire app_sr_active;
	wire app_ref_ack;
	wire app_zq_ack;
	wire ui_clk;
	wire ui_clk_sync_rst;
	wire [11:0] device_temp = 0;
	wire sys_rst = (pwr_on_rst_ctr == 0);

	wire clk_ref_i; // temp
	assign clk_ref_i = sys_clk_i;
	
	always @ (posedge sys_clk_i)
	begin
		if (pwr_on_rst_ctr)
		begin
			pwr_on_rst_ctr <= pwr_on_rst_ctr - 1 ;
		end
	end

`ifdef SKIP_CALIB // skip calibration wires
	wire calib_tap_req;
	reg calib_tap_load;
	reg [6:0] calib_tap_addr;
	reg [7:0] calib_tap_val;
	reg calib_tap_load_done;
`endif

	ExternalMemory _ExternalMemory (
		// DDR3 Physical interface ports
		.ddr3_addr   (ddr3_addr),
		.ddr3_ba     (ddr3_ba),
		.ddr3_cas_n  (ddr3_cas_n),
		.ddr3_ck_n   (ddr3_ck_n),
		.ddr3_ck_p   (ddr3_ck_p),
		.ddr3_cke    (ddr3_cke),
		.ddr3_ras_n  (ddr3_ras_n),
		.ddr3_reset_n(ddr3_reset_n),
		.ddr3_we_n   (ddr3_we_n),
		.ddr3_dq     (ddr3_dq),
		.ddr3_dqs_n  (ddr3_dqs_n),
		.ddr3_dqs_p  (ddr3_dqs_p),
		.ddr3_cs_n   (ddr3_cs_n),
		.ddr3_dm     (ddr3_dm),
		.ddr3_odt    (ddr3_odt),

		.init_calib_complete (calib_done),

		// User interface ports
		.app_addr    (app_addr),
		.app_cmd     (app_cmd),
		.app_en      (app_en),
		.app_wdf_data(app_wdf_data),
		.app_wdf_end (app_wdf_end),
		.app_wdf_wren(app_wdf_wren),
		.app_rd_data (app_rd_data),
		.app_rd_data_end (app_rd_data_end),
		.app_rd_data_valid (app_rd_data_valid),
		.app_rdy     (app_rdy),
		.app_wdf_rdy (app_wdf_rdy),
		.app_sr_req  (app_sr_req),
		.app_ref_req (app_ref_req),
		.app_zq_req  (app_zq_req),
		.app_sr_active(app_sr_active),
		.app_ref_ack (app_ref_ack),
		.app_zq_ack  (app_zq_ack),
		.ui_clk      (ui_clk),
		.ui_clk_sync_rst (ui_clk_sync_rst),
		.app_wdf_mask(app_wdf_mask),
		// Clock and Reset input ports
		.sys_clk_i (sys_clk_i),
		.sys_rst (resetn)
		);





	
	assign instruction = instr_mem[PC];

endmodule

`endif /*__INSTRUCTIONMEMORY_V__*/
