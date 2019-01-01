`ifndef __DATAMEMORY_V__
`define __DATAMEMORY_V__

module DataMemory # (
	parameter DQ_WIDTH = 16, // # of DQ(data)
	parameter ECC_TEST = "OFF",
	parameter nBANK_MACHS = 4,
	parameter ADDR_WIDTH = 28, // # = RANK_WIDTH + BANK_WIDTH + ROW_WIDTH + COL_WIDTH
	parameter nCK_PER_CLK = 4 // # of memory CKs per fabric CLK
	)	(
	input wire [31:0] Address,
	input wire [31:0] Write_data,
	input wire Mem_Write,
	input wire Mem_Read,
	output wire [31:0] Read_data,

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
	// output reg led_pass, // J2
	// output reg led_fail, // K1
	// output wire led_calib, // G4

	// Inputs
	input wire sys_clk_i
	);
	
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

	// reg [9:0] pwr_on_rst_ctr = 1023;
	// wire sys_rst = (pwr_on_rst_ctr == 0);

	wire clk_ref_i; // temp
	assign clk_ref_i = sys_clk_i; // Reference Clock Port is also okay to use system clock.
	
	// always @ (posedge sys_clk_i)
	// begin
		// if (pwr_on_rst_ctr)
		// begin
			// pwr_on_rst_ctr <= pwr_on_rst_ctr - 1 ;
		// end
	// end

`ifdef SKIP_CALIB // skip calibration wires
	wire calib_tap_req;
	reg calib_tap_load;
	reg [6:0] calib_tap_addr;
	reg [7:0] calib_tap_val;
	reg calib_tap_load_done;
`endif

	ExternalMemory _ExternalMemory
	(
		// Memory interface ports
		.ddr3_dq(ddr3_dq),
		.ddr3_dqs_n(ddr3_dqs_n),
		.ddr3_dqs_p(ddr3_dqs_p),

		.ddr3_addr(ddr3_addr),
		.ddr3_ba(ddr3_ba),
		.ddr3_ras_n(ddr3_ras_n),
		.ddr3_cas_n(ddr3_cas_n),
		.ddr3_we_n(ddr3_we_n),
		.ddr3_reset_n(ddr3_reset_n),
		.ddr3_ck_p(ddr3_ck_p),
		.ddr3_ck_n(ddr3_ck_n),
		.ddr3_cke(ddr3_cke),
		.ddr3_cs_n(ddr3_cs_n),
		.ddr3_dm(ddr3_dm),
		.ddr3_odt(ddr3_odt),

		// Application interface ports
		.app_addr(app_addr),
		.app_cmd(app_cmd),
		.app_en(app_en),
		.app_wdf_data(app_wdf_data),
		.app_wdf_end(app_wdf_end),
		.app_wdf_mask(app_wdf_mask),
		.app_wdf_wren(app_wdf_wren),
		.app_rd_data(app_rd_data),
		.app_rd_data_end(app_rd_data_end),
		.app_rd_data_valid(app_rd_data_valid),
		.app_rdy(app_rdy),
		.app_wdf_rdy(app_wdf_rdy),
		.app_sr_req(1'b0),
		.app_ref_req(1'b0),
		.app_zq_req(1'b0),
		.app_sr_active(app_sr_active),
		.app_ref_ack(app_ref_ack),
		.app_zq_ack(app_zq_ack),
		.ui_clk(ui_clk),
		.ui_clk_sync_rst(ui_clk_sync_rst),
		.init_calib_complete(init_calib_complete),
		.device_temp(device_temp),

		.sys_clk_i(sys_clk_i), // System Clock Ports
		.clk_ref_i(clk_ref_i), // Reference Clock Ports
		.sys_rst(sys_rst)

`ifdef SKIP_CALIB
		,
		.calib_tap_req(calib_tap_req),
		.calib_tap_load(calib_tap_load),
		.calib_tap_addr(calib_tap_addr),
		.calib_tap_val(calib_tap_val),
		.calib_tap_load_done(calib_tap_load_done)
`endif
	);

	reg [2:0] state = STATE_INIT;

	localparam CMD_WRITE = 3'b000;
	localparam CMD_READ = 3'b001;

	localparam STATE_INIT = 3'd0;
	localparam STATE_READY = 3'd1;
	localparam STATE_READ = 3'd2;
	localparam STATE_READ_DONE = 3'd3;
	localparam STATE_WRITE = 3'd4;
	localparam STATE_WRITE_DONE = 3'd5;

	reg [127:0] data_to_write;
	reg [127:0] data_read_from_memory = 0;

	always @ (ui_clk)
	begin
		if (Mem_Read)
		begin
			if (app_rdy)
			begin
				if (Address < 32'h10000000) // 32'h10000000 = 256MB
				begin
					app_addr <= Address[ADDR_WIDTH-1:0];
					app_en <= 1;
					app_cmd <= CMD_READ;
					state <= STATE_READ_DONE;
				end
			end
		end
		if (Mem_Write)
		begin
			if (app_rdy & app_wdf_rdy)
			begin
				if (Address < 32'h10000000) // 32'h10000000 = 256MB
				begin
					app_en <= 1;
					app_wdf_wren <= 1;
					app_addr <= 0;
					app_cmd <= CMD_WRITE;
					app_wdf_data <= Write_data;
					state <= STATE_WRITE_DONE;
				end
			end
		end
	end
	
	assign Read_data = data_read_from_memory[31:0];

	always @ (posedge ui_clk)
	begin
		if (ui_clk_sync_rst)
		begin
			state <= STATE_INIT;
			app_en <= 0;
			app_wdf_wren <= 0;
		end
		else
		begin
			case (state)
				STATE_INIT:
				begin
					if (init_calib_complete)
					begin
						state <= STATE_READY;
					end
				end
				
				STATE_READY:
				begin
					state <= STATE_READY;
				end

				STATE_READ: // 무슨 소용?
				begin
					if (app_rdy)
					begin
						app_en <= 1;
						app_addr <= 0;
						app_cmd <= CMD_READ;
						state <= STATE_READ_DONE;
					end
				end

				STATE_READ_DONE:
				begin
					if (app_rdy & app_en)
					begin
						app_en <= 0;
					end

					if (app_rd_data_valid)
					begin
						data_read_from_memory <= app_rd_data;
						state <= STATE_READY;
					end
				end

				STATE_WRITE: // 무슨 소용?
				begin
					if (app_rdy & app_wdf_rdy)
					begin
						app_en <= 1;
						app_wdf_wren <= 1;
						app_addr <= 0;
						app_cmd <= CMD_WRITE;
						app_wdf_data <= data_to_write;
						state <= STATE_WRITE_DONE;
					end
				end

				STATE_WRITE_DONE:
				begin
					if (app_rdy & app_en)
					begin
						app_en <= 0;
					end

					if (app_wdf_rdy & app_wdf_wren)
					begin
						app_wdf_wren <= 0;
					end

					if (~app_en & ~app_wdf_wren)
					begin
						state <= STATE_READY;
					end
				end

				default:
				begin
					state <= STATE_INIT;
				end
			endcase
		end
	end

endmodule

`endif /*__DATAMEMORY_V__*/
