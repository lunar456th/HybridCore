/*
	Name				:	Register File Module
	Word size			:	16-bit
	Number of registers	:	32
	Total size			:	64 Bytes
*/

module regfile (
	input wire clk,
	input wire reset,
	input wire r_en_a,
	input wire r_en_b,
	input wire w_en,
	input wire [4:0] r_idx_a,
	input wire [4:0] r_idx_b,
	input wire [4:0] w_idx,
	input wire [15:0] w_data,
	output reg [15:0] r_data_a,
	output reg [15:0] r_data_b,
	);
	
	reg [15:0] register[0:31];
	
	integer i;
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			r_data_a <= 0;
			r_data_b <= 0;
			for (i = 0; i < 32; i = i + 1)
				register[i] <= 16'b0;
		end
		
		if (r_en_a)
			r_data_a <= register[r_idx_a];
		
		if (r_en_b)
			r_data_b <= register[r_idx_b];
		
		if (w_en)
			register[w_idx] <= w_data;
	end
	
endmodule
