`ifndef __INSTRUCTIONMEMORY_V__
`define __INSTRUCTIONMEMORY_V__

module InstructionMemory (
	input wire [31:0] PC,
	output wire [31:0] instruction
	);

	reg [31:0] instr_mem[0:63];
	wire[31:0] loc0, loc4, loc8, loc12, loc16, loc20, loc24;
	integer i;

	assign loc0 = instr_mem[0];
	assign loc4 = instr_mem[1];
	assign loc8 = instr_mem[2];
	assign loc12 = instr_mem[3];
	assign loc16 = instr_mem[4];
	assign loc20 = instr_mem[5];
	assign loc24 = instr_mem[6];


	initial // for test
	begin
		instr_mem[0] <= 32'h012A4020; // add R8, R9, R10
		instr_mem[1] <= 32'h012A4023; // sub R8, R9, R10
		instr_mem[2] <= 32'h212A000C; // addi R10, R9, 12
		instr_mem[3] <= 32'h01090018; // mult R0, R8, R9
		instr_mem[4] <= 32'h012A4024; // and R7, R3, R4
		instr_mem[5] <= 32'h34CE0002; // ori R14, R6, 2
		instr_mem[6] <= 32'h8D28000C; // lw
		instr_mem[7] <= 32'h2128000D;
		instr_mem[8] <= 32'h212B000D; // add

		for (i = 9; i < 64; i = i + 1)
		begin
			instr_mem[i] <= 0;
		end
	end
	
	assign instruction = instr_mem[PC];

endmodule

`endif /*__INSTRUCTIONMEMORY_V__*/
