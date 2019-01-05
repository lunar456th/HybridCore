`ifndef __INSTRUCTIONMEMORY_V__
`define __INSTRUCTIONMEMORY_V__

module InstructionMemory (
	input wire [31:0] PC,
	output wire [31:0] instruction,
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

	assign instruction = memory[PC];

endmodule

`endif /*__INSTRUCTIONMEMORY_V__*/
