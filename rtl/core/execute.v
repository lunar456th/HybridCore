/*
	Name		:	Execution Unit
	File		:	execute.v
	Word size	:	16-bit
*/

`include "defines.v"

module execute (
	input wire clk,
	input wire reset,


	input wire [4:0] of_ex_op,
	input wire [15:0] of_ex_operand_a,
	input wire [15:0] of_ex_operand_b,
	input wire [4:0] of_ex_reg_idx_dst,
	
	input wire [3:0] of_ex_branch_cond, ///////
	input wire [4:0] of_ex_pc,
	input wire of_ex_has_writeback,
	
	output reg reg_r_en,
	output reg [15:0] reg_r_idx,
	input wire [15:0] reg_r_data,

	output reg reg_w_en,
	output reg [15:0] reg_w_idx,
	output reg [15:0] reg_w_data,

	output reg mem_r_en,
	output reg [15:0] mem_r_addr,
	input wire [15:0] mem_r_data,
	output reg mem_w_en,
	output reg [15:0] mem_w_addr,
	output reg [15:0] mem_w_data,
	
	output reg [15:0] ex_wb_result,
	output reg [3:0] ex_wb_nzcv,
	output wire [4:0] ex_wb_reg_idx_dst,
	output wire [15:0] ex_wb_operand_b,
	output wire ex_wb_has_writeback,
	
	output wire ex_if_branch_en, /////////////
	output wire [15:0] ex_if_branch_target, //////////////
	);
	
	assign ex_wb_reg_idx_dst = of_ex_reg_idx_dst;
	assign 
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			ex_wb_result = 0;
			ex_wb_nzcv = 0;
			ex_wb_reg_idx_dst = 0;
		end
		else
		begin
			casex (of_ex_op) // ...
				OP_ALU:
				begin
					alu alu(
						.op(of_ex_op),
						.a(of_ex_operand_a),
						.b(of_ex_operand_b),
						.result(ex_wb_result),
						.nzcv(ex_wb_nzcv)
					);
					if (of_ex_op == OP_CMP)
					begin
						if ((of_ex_branch_cond == 4'b0000) || 
							(of_ex_branch_cond == 4'b0010 && ex_wb_nzcv) || 
							(of_ex_branch_cond == 4'b0011 && ex_wb_nzcv[2] == 1'b1) || 
							(of_ex_branch_cond == 4'b1000 && ex_wb_nzcv[2] == 1'b0) || 
							(of_ex_branch_cond == 4'b1001 && ex_wb_nzcv[2] == 1'b0 && ex_wb_nzcv[1] == 1'b1) || 
							(of_ex_branch_cond == 4'b1001 && ex_wb_nzcv[1] == 1'b1) || 
							(of_ex_branch_cond == 4'b1010 && ex_wb_nzcv[1] == 1'b0) || 
							(of_ex_branch_cond == 4'b1011 && ex_wb_nzcv[2] == 1'b1 && ex_wb_nzcv[1] == 1'b0) || 
							(of_ex_branch_cond == 4'b1100 && ex_wb_nzcv[3] != ex_wb_nzcv[0]) || 
							(of_ex_branch_cond == 4'b1101 && ex_wb_nzcv[3] != ex_wb_nzcv[0] && ex_wb_nzcv[2] == 1'b1) || 
							(of_ex_branch_cond == 4'b1110 && ex_wb_nzcv[3] == ex_wb_nzcv[0] && ex_wb_nzcv[2] == 1'b0) || 
							(of_ex_branch_cond == 4'b1111 && ex_wb_nzcv[3] == ex_wb_nzcv[0]))
						begin
							// pc값 수정
						end
					end
				end
				5'b10000: // mov operation
					ex_wb_result <= of_ex_operand_b;
				5'b10010: // load operation
				begin
					mem_r_addr = of_ex_operand_b;
					mem_r_en = 1'b1;
					ex_wb_result = mem_r_data;
				end
				5'b10011: // store operation
					ex_wb_result <= of_ex_operand_b;
				5'b10100: // MSR
				begin
					ex_wb_result <= of_ex_operand_b;
					ex_wb_reg_idx_dst <= REG_CPSR;
				end
				5'b10101: // MRS
				begin
					reg_r_idx = REG_CPSR;
					reg_r_en = 1'b1;
					ex_wb_result = reg_r_data;
				end
				5'b10110: // PUSH
				begin
					ex_wb_result <= of_ex_operand_b;
				end
				5'b10111: // POP
				begin
					reg_r_idx = REG_SP;
					reg_r_en = 1'b1;
					mem_r_addr = reg_r_data;
					mem_r_en = 1'b1;
					ex_wb_result = mem_r_data;
				end
				5'b11000: // branch operation
				begin
					if (of_ex_branch_cond[3]
					reg_w_idx = REG_PC;
					reg_w_en = 1'b1;
					reg_w_data = of_ex_operand_a;
				5'b11010: // CALL
					// PC 주소를 스택에 push하고 jmp
				5'b11011: // RET
					// pc 주소를 스택에서 pop해서 jmp
				5'b11100: // INT
					// 컨텍스트 저장 후 Interrupt Vector Table 참조로 PC값 변경
				default:;
			endcase
		end
	end
	
endmodule
