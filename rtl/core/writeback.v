/*
	Name		:	Write-back Unit
	File		:	writeback.v
	Word size	:	16-bit
*/

`include "defines.v"

module writeback (
	input wire clk,
	input wire reset,
	
	input wire [15:0] ex_wb_result,
	input wire [3:0] ex_wb_nzcv,
	input wire [4:0] ex_wb_reg_idx_dst,
	input wire [4:0] ex_wb_op,
	input wire [15:0] ex_wb_operand_b,
	input wire ex_wb_has_writeback,
	
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
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			wb_ex_bypass_reg <= 0;
			wb_ex_bypass_value <= 0;
			wb_ex_has_bypass <= 0;
		end
		else
		begin
			wb_ex_bypass_reg <= ex_wb_reg_idx_dst;
			wb_ex_bypass_value <= ex_wb_result;
			wb_ex_has_bypass <= ex_wb_has_writeback;

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
			endcase
		end
	end
	
endmodule
