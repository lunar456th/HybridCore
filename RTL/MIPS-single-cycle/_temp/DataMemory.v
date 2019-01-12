`ifndef __DATAMEMORY_V__
`define __DATAMEMORY_V__

module DataMemory (
	input wire [31:0] Address,
	input wire [31:0] Write_data,
	input wire Mem_Write,
	input wire Mem_Read,
	output wire [31:0] Read_data

	output [31:0] memory_addr,
	output memory_rden,
	output memory_wren,
	input [31:0] memory_read_val,
	output [31:0] memory_write_val
	input wire memory_response
	);

	always @ (Address)
	begin
		if (Mem_Read)
		begin
			memory_addr <= Address;
			memory_rden <= 1'b1;
		end

		if (Mem_Write)
		begin
			memory_addr <= Address;
			memory_wren <= 1'b1;
			memory_write_val <= Write_data;
		end
	end

	always @ (posedge memory_response)
	begin
		if (memory_rden)
		begin
			Read_data <= memory_read_val;
			memory_rden <= 1'b0;
		end

		if (memory_wren)
		begin
			memory_wren <= 1'b0;
		end
	end

endmodule

`endif /*__DATAMEMORY_V__*/
