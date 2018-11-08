/*
	Name		:	Operand Fetch Unit
	File		:	ofetch.v
	Word size	:	16-bit
*/

module operand_fetch (
	input wire clk,
	input wire reset,
	
	input wire [4:0] id_of_op,
	input wire id_of_addr_mode,
	input wire [4:0] id_of_reg_idx_a,
	input wire [4:0] id_of_reg_idx_b,
	input wire [4:0] id_of_imm,
	input wire [3:0] id_of_branch_cond,
	input wire [15:0] id_of_pc,
	input wire id_of_has_writeback,
	
	output reg reg_r_en_a,
	output reg [15:0] reg_r_idx_a,
	input wire [15:0] reg_r_data_a,
	output reg reg_r_en_b,
	output reg [15:0] reg_r_idx_b,
	input wire [15:0] reg_r_data_b,
	output reg reg_w_en,
	output reg [15:0] reg_w_idx,
	output reg [15:0] reg_w_data,
	
	output wire [4:0] of_ex_op,
	output reg [15:0] of_ex_operand_a,
	output reg [15:0] of_ex_operand_b,
	output wire [3:0] of_ex_branch_cond,
	output wire [4:0] of_ex_pc,
	output wire of_ex_has_writeback
	output wire [4:0] of_ex_reg_idx_dst,

	);
	
	parameter ADDR_MODE_DIRECT = 1'b0;
	parameter ADDR_MODE_IMMEDIATE = 1'b1;
	
	assign of_ex_op = id_of_op;
	assign of_ex_branch_cond = id_of_branch_cond;
	assign of_ex_pc = id_of_pc;
	assign of_ex_has_writeback = of_ex_has_writeback;
	assign of_ex_reg_idx_dst = id_of_reg_idx_a;
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			of_ex_op <= 0;
			of_ex_operand_a <= 0;
			of_ex_operand_b <= 0;
			of_ex_branch_cond <= 0;
			of_ex_pc <= 0;
			of_ex_has_writeback <= 0;
			of_ex_reg_idx_dst <= 0;
		end
		else
		begin
			reg_r_idx_a = id_of_reg_idx_a;
			reg_r_en_a = 1'b1;//////////////////
			of_ex_operand_a = reg_r_data_a;
			
			if (id_of_addr_mode == ADDR_MODE_DIRECT)
			begin
				reg_r_idx_b = id_of_reg_idx_b;
				reg_r_en_b = 1'b1;//////////////////
				of_ex_operand_b = reg_r_data_b;
			end
			else if (id_of_addr_mode == ADDR_MODE_IMMEDIATE)
			begin
				of_ex_operand_b = id_of_imm;
			end
		end
	end
	
endmodule
