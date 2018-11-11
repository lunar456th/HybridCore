/*
	Name		:	Execution Unit
	File		:	execute.v
	Word size	:	16-bit
*/

module execute (
	input wire clk,
	input wire reset,


	input wire [4:0] of_ex_op,
	input wire [15:0] of_ex_operand_a,
	input wire [15:0] of_ex_operand_b,
	input wire [4:0] of_ex_reg_idx_dst,
	
	output wire [3:0] of_ex_branch_cond, ///////
	output wire [4:0] of_ex_pc,
	output wire of_ex_has_writeback,
	
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
	
	output wire ex_if_branch_en, /////////////
	output wire [15:0] ex_if_branch_target, //////////////
	);
	
	parameter REG_R0 0;
	parameter REG_R1 1;
	parameter REG_R2 2;
	parameter REG_R3 3;
	parameter REG_R4 4;
	parameter REG_R5 5;
	parameter REG_R6 6;
	parameter REG_R7 7;
	parameter REG_R8 8;
	parameter REG_R9 9;
	parameter REG_R10 10;
	parameter REG_R11 11;
	parameter REG_R12 12;
	parameter REG_R13 13;
	parameter REG_R14 14;
	parameter REG_R15 15;
	parameter REG_R16 16;
	parameter REG_R17 17;
	parameter REG_R18 18;
	parameter REG_R19 19;
	parameter REG_R20 20;
	parameter REG_R21 21;
	parameter REG_R22 22;
	parameter REG_R23 23;
	parameter REG_R24 24;
	parameter REG_R25 25;
	parameter REG_R26 26;
	parameter REG_R27 27;
	parameter REG_SP 28;
	parameter REG_BP 29;
	parameter REG_PC 30;
	parameter REG_CPSR 31;
	
	// Arithmetic Operations
	parameter OP_ALU = 5'b0xxxx;
	parameter OP_ADD = 5'b00000;
	parameter OP_SUB = 5'b00001;
	parameter OP_MUL = 5'b00010;
	parameter OP_DIV = 5'b00011;
	// Logic Operations
	parameter OP_AND = 5'b00100;
	parameter OP_NAND = 5'b00101;
	parameter OP_OR = 5'b00110;
	parameter OP_NOR = 5'b00111;
	parameter OP_XOR = 5'b01000;
	parameter OP_XNOR = 5'b01001;
	// Shift Operations
	parameter OP_SHL = 5'b01010;
	parameter OP_SHR = 5'b01011;
	parameter OP_ROL = 5'b01100;
	parameter OP_ROR = 5'b01101;
	parameter OP_ASR = 5'b01110;
	// Comparation Operations
	parameter OP_CMP = 5'b01111;
	
	assign ex_wb_reg_idx_dst = of_ex_reg_idx_dst;
	
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
