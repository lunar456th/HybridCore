/*
	Name		:	Decode Unit
	File		:	decode.v
	Word size	:	16-bit
	Detail of Instruction	:	[15:11]	- OpCode
								[10]	- Adressing Mode(Direct Mode or Immediate Mode)
								[9:5]	- Operand A(Register Index)
								[4:0]	- Operand B(Register Index or Immediate)
*/

module decode (
	input wire clk,
	input wire reset,
	
	input wire [15:0] if_id_pc,
	input wire [15:0] if_id_instr,
	output reg [15:0] id_of_op,
	output reg id_of_addr_mode,
	output reg [4:0] id_of_reg_idx_a,
	output reg [4:0] id_of_reg_idx_b,
	output reg [4:0] id_of_imm,
	output reg [3:0] id_of_branch_cond,
	output reg [15:0] id_of_pc,
	output reg id_ex_has_writeback
	);
	
	parameter OP_JMP = 5'b11000;
	
	always @ (posedge clk or negedge reset)
	begin
		if(~reset)
		begin
			id_of_op <= 0;
			id_of_addr_mode <= 0;
			id_of_reg_idx_a <= 0;
			id_of_reg_idx_b <= 0;
			id_of_branch_cond <= 0;
			id_ex_has_writeback <= 0;
		end
		else
		begin
			id_of_op <= if_id_instr[15:11];
			id_of_addr_mode <= if_id_instr[10];
			id_of_reg_idx_a <= if_id_instr[9:5];
			id_of_reg_idx_b <= if_id_instr[4:0];
			id_of_imm <= if_id_instr[4:0];
			id_of_branch_cond <= if_id_instr[3:0];
			if (if_id_instr[15:11] == OP_JMP)
				id_ex_has_writeback <= 1'b1;
			else
				id_ex_has_writeback <= 1'b0;
		end
	end
	
endmodule
