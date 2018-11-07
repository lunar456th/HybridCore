module execute (
	input wire [4:0] opcode,
	input wire addr_mode,
	input wire [4:0] reg_idx_a,
	input wire [4:0] reg_idx_b,
	input wire [3:0] cond,
	
	output reg [15:0] mem_r_addr,
	output reg [15:0] mem_w_addr,
	output reg [15:0] mem_r_data,
	output reg [15:0] mem_w_data,
	output reg mem_r_en,
	output reg mem_w_en,

	output reg [15:0] reg_r_idx_a,
	output reg [15:0] reg_r_idx_b,
	output reg [15:0] reg_w_idx,
	output reg [15:0] reg_r_data_a,
	output reg [15:0] reg_r_data_b,
	output reg [15:0] reg_w_data,
	output reg reg_r_en_a,
	output reg reg_r_en_b,
	output reg reg_w_en
	);
	
	reg [15:0] operand_a;
	reg [15:0] operand_b;
	
	//
	
endmodule
