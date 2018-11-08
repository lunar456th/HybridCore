/*
	Name			:	Instruction Cache Memory Module
	File			:	icache.v
	Word size		:	16-bit
	Number of words	:	256
	Total size		:	1K Bytes
	R/W Mode		:	Read Only
*/

module icache (
	input wire clk,
	input wire reset,
	input wire r_en,
	input wire [15:0] addr,
	output reg [15:0] data
	);
	
	reg [15:0] mem[0:255];
	
	integer i;
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			data <= 0;
			for (i = 0; i < 256; i = i + 1)
				mem[i] = i;
		end
		
		if (r_en == 1'b1)
			data <= mem[addr];
	end
	
endmodule
