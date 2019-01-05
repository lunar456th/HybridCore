module main # (
	)	(


module Processor # (
    parameter NUM_CORES = 16,
	parameter DQ_WIDTH = 16,
	parameter ECC_TEST = "OFF",
	parameter nBANK_MACHS = 4,
	parameter ADDR_WIDTH = 28,
	parameter nCK_PER_CLK = 4
	)	(
	input clk, // 클락
	input reset, // 리셋
	
	// AXI Memory In/Out Ports
	inout [15:0] ddr3_dq,
	inout [1:0] ddr3_dqs_n,
	inout [1:0] ddr3_dqs_p,
	output [13:0] ddr3_addr,
	output [2:0] ddr3_ba,
	output ddr3_ras_n,
	output ddr3_cas_n,
	output ddr3_we_n,
	output ddr3_reset_n,
	output [0:0] ddr3_ck_p,
	output [0:0] ddr3_ck_n,
	output [0:0] ddr3_cke,
	output [0:0] ddr3_cs_n,
	output [1:0] ddr3_dm,
	output [0:0] ddr3_odt,

	// AXI Memory 와 소통하는 in/out
	output [31:0] device_addr,
	output device_read_en,
	output device_write_en,
	input [31:0] device_data_in,
	output [31:0] device_data_out,

	output reg [$clog2(NUM_CORES)-1:0] device_core_id,

	input axi_we, // response
	input [31:0] axi_addr, // response
	input [31:0] axi_data, // response
	output [31:0] axi_q // ?
	);

	wire [31:0] memory_addr;
	wire memory_rden;
	wire memory_wren;
	wire [31:0] memory_read_val;
	wire [31:0] memory_write_val;

	wire [31:0] core_memory_addr[0:NUM_CORES-1];
	wire core_memory_rden [NUM_CORES-1:0];
	wire core_memory_wren [NUM_CORES-1:0];
	wire [31:0] core_memory_write_val[0:NUM_CORES-1];

	wire [NUM_CORES-1:0] core_enable; // 글로벌 메모리에 접근할 권한 같음. 잘은 모르겠음, 지금은 안쓰임
	wire [NUM_CORES-1:0] core_request; // 글로벌 메모리 접근 요청, 지금은 안쓰임

	assign memory_addr = core_memory_addr[device_core_id];
	assign memory_rden = core_memory_rden[device_core_id];
	assign memory_wren = core_memory_wren[device_core_id];
	assign memory_write_val = core_memory_write_val[device_core_id];

    assign device_addr = memory_addr;
    assign device_read_en = memory_rden;
    assign device_write_en = memory_wren;
    assign memory_read_val = device_data_in;
    assign device_data_out = memory_write_val;
	

	genvar i;
	generate
		for (i = 0; i < NUM_CORES; i = i + 1)
		begin
			Core # (
				.LOCAL_MEMORY_SIZE(LOCAL_MEMORY_SIZE)
			) _Core (
				.clk(clk),
				.reset(reset),
				.core_enable(core_enable[i]),
				.core_request(core_request[i]),
				.memory_addr(core_memory_addr[i]),
				.memory_wren(core_memory_wren[i]),    
				.memory_rden(core_memory_rden[i]),
				.memory_write_val(core_memory_write_val[i]),
				.memory_read_val(memory_read_val)
			);
		end
	endgenerate


	// Convert one-hot to binary = encoding?
    integer oh_index;
    always @*
    begin : convert
        device_core_id = 0;
        for (oh_index = 0; oh_index < NUM_CORES; oh_index = oh_index + 1)
        begin
            if (core_enable[oh_index])
            begin : convert
                 // Use 'or' to avoid synthesizing priority encoder
                device_core_id = device_core_id | oh_index[$clog2(NUM_CORES) - 1:0];
            end
        end
    end


	// Dynamic Arbitration for accessing external memory using arbiter
	Arbiter # (
		.NUM_CORES(NUM_CORES)
	) _Arbiter(
		.clk(clk),
		.reset(reset),
		.request(core_request),
		.core_select(core_enable)
	);


	localparam STATE_IDLE = 3'd0;
	localparam STATE_WRITE = 3'd1;
	localparam STATE_WRITE_DONE = 3'd2;
	localparam STATE_READ = 3'd3;
	localparam STATE_READ_DONE = 3'd4;
	localparam STATE_PARK = 3'd5;

	reg [127:0] data_to_write = { 32'hcafecafe, 32'hfaceface, 32'hbabebabe, 32'hABCD1234 };
	reg [127:0] data_read_from_memory = 128'd0;
	reg [9:0] pwr_on_rst_ctr = 1023;

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

	always @ (posedge clk)
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


	// External Memory Interface
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

		.sys_clk_i(clk),
		.clk_ref_i(clk),
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

	// 메모리 요청 트래픽에 따라 메모리를 read/write하는 state machine이 필요.


endmodule
