/*
	Name			:	Top Module of SimpleCore
	Word size		:	16-bit
	Components		:	
*/

module top (
	input wire clk,
	input wire reset
	);

	wire dcache_r_en;
	wire dcache_w_en;
	wire [15:0] dcache_addr;
	wire [15:0] dcache_w_data;
	wire [15:0] dcache_r_data;

	wire icache_r_en;
	wire [15:0] icache_addr;
	wire [15:0] icache_data;

	wire regfile_w_en;
	wire [4:0] regfile_w_addr;
	wire [15:0] regfile_w_data;
	wire [4:0] regfile_r_addr_a;
	wire [4:0] regfile_r_addr_b;
	wire [15:0] regfile_r_data_a;
	wire [15:0] regfile_r_data_b;
	
	wire [4:0] alu_op;
	wire [15:0] alu_a;
	wire [15:0] alu_b;
	wire alu_c_in;
	wire [15:0] alu_result;
	wire [3:0] alu_nzcv;

endmodule
