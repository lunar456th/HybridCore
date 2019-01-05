module Processor # (
    parameter NUM_CORES = 16
	)	(
	input clk, // 클락
	input reset, // 리셋

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

	// Dynamic Arbitration using arbiter
	Arbiter #( 
		.NUM_CORES(NUM_CORES)
	) _Arbiter(
		.clk(clk),
		.reset(reset),
		.request(core_request),
		.core_select(core_enable)
	);

endmodule
