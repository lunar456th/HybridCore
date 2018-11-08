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
	input wire [4:0] ex_wb_reg_idx_dst
	
	output reg reg_w_en,
	output reg [15:0] reg_w_idx,
	output reg [15:0] reg_w_data,
	
	output reg mem_w_en,
	output reg [15:0] mem_w_addr,
	output reg [15:0] mem_w_data,
	
	output reg wb_ /////////////
	);
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			//
		end
		else
		begin
			//
		end
	end
	
endmodule
