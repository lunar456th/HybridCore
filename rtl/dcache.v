/*
	Name			:	Data Cache Memory Module
	Word size		:	16-bit
	Number of words	:	256
	Total size		:	1K Bytes
	R/W Mode		:	Read/Write
*/

module dcache (
	input wire clk,
	input wire r_en,
	input wire w_en,
	input wire [15:0] addr,
	input wire [15:0] w_data,
	output reg [15:0] r_data
	);
	
	reg [15:0] mem[0:255];
	
	integer i;
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			r_data <= 0;
			for (i = 0; i < 256; i = i + 1)
				mem[i] = i;
		end
		
		if (w_en == 1'b1)
			mem[addr] <= w_data;
		
		if (r_en == 1'b1)
			r_data <= mem[addr];
	end
	
endmodule
