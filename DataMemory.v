`ifndef __DATAMEMORY_V__
`define __DATAMEMORY_V__

module DataMemory (
	input wire [31:0] Address,
	input wire [31:0] Write_data,
	input wire Mem_Write,
	input wire Mem_Read,
	output wire [31:0] Read_data
	);
	
	reg [15:0] memory[0:31];
	integer i;
	
	initial
	begin
		memory[0] <= 16'h0;
		memory[1] <= 16'h0;
		memory[2] <= 16'h0;
		memory[3] <= 16'h0;
		memory[4] <= 16'h0;
		memory[5] <= 16'h0;
		memory[6] <= 16'h0;
		memory[7] <= 16'h0;
		for(i = 8; i < 16; i = i + 1)
		begin
			memory[i] <= 16'h0;
		end
	end
	
	always @ (Address)
	begin
		if (Mem_Write)
		begin
			memory[Address] <= Write_data;
		end
		
		if (Mem_Read)
		begin
			Read_data <= memory[Address];
		end
	end

endmodule

`endif /*__DATAMEMORY_V__*/
