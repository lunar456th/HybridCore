`ifndef __INSTRUCTIONMEMORY_V__
`define __INSTRUCTIONMEMORY_V__

module InstructionMemory (
	input wire [31:0] PC,
	output reg [31:0] instruction,
	output reg [31:0] memory_addr,
	output reg memory_rden,
	input wire [31:0] memory_read_val,
	input wire memory_response
	);

	always @ (PC)
	begin
		memory_addr <= PC;
		memory_rden <= 1'b1;
	end

	always @ (posedge memory_response)
	begin
		if (memory_rden)
		begin
			instruction <= memory_read_val;
			memory_rden <= 1'b0;
		end
	end

endmodule

`endif /*__INSTRUCTIONMEMORY_V__*/
