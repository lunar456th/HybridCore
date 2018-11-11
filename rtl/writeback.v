/*
	Name		:	Write-back Unit
	File		:	writeback.v
	Word size	:	16-bit
*/

module writeback (
	input wire clk,
	input wire reset,
	
	input wire [15:0] ex_wb_result,
	input wire [3:0] ex_wb_nzcv,
	input wire [4:0] ex_wb_reg_idx_dst,
	input wire [4:0] ex_wb_op,
	input wire [15:0] ex_wb_operand_b,
	
	output reg reg_w_en,
	output reg [15:0] reg_w_idx,
	output reg [15:0] reg_w_data,
	
	output reg mem_w_en,
	output reg [15:0] mem_w_addr,
	output reg [15:0] mem_w_data,
	
	output reg [2:0] wb_ex_bypass_reg, /////
	output reg [15:0] wb_ex_bypass_value,
	output reg wb_ex_has_bypass
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
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			
		end
		else
		begin
			casex (ex_wb_op)
				5'b00xxx, 5'b010xx, 5'b0110x, 5'b01110: // ALU except CMP
				5'b10000: // MOV 
				5'b10010: // LD
				5'b10100: // MSR
				5'b10101: // MRS
				5'b10111: // POP
				begin
					reg_w_idx = ex_wb_reg_idx_dst;
					reg_w_en = 1'b1;
					reg_w_data = ex_wb_result;
				end
				5'b10011: // STR
				begin
					mem_w_addr = ex_wb_result;
					mem_w_en = 1'b1;
					mem_w_data = ex_wb_operand_b;
				end
				5'b10110: // PUSH
				begin
					reg_r_addr = REG_SP;
					reg_r_en = 1'b1;
					mem_w_addr = reg_r_data;
					mem_w_en = 1'b1;
					mem_w_data = ex_wb_result;
				end
				default:; /////////
		end
	end
	
endmodule
