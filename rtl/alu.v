// 1. 사용할 가산기, 승산기, 제산기, 쉬프터 import하기

/*
	Name		:	Arithmetic Logic Unit
	Word size	:	16-bit
	Operations	:	ADD, SUB, MUL, DIV, SHL, SHR, ROL, ROR, AND, OR, XOR, XNOR, NAND, NOR, CMP
	Adder		:	Kogge Stone Adder
	Multiplier	:	Fast Multiplier
	Divider		:	Fast Divider
	Shifter		:	Fast Shifter
*/

// Arithmetic Operations
`define ALU_OP_ADD 5'b00000
`define ALU_OP_SUB 5'b00001
`define ALU_OP_MUL 5'b00010
`define ALU_OP_DIV 5'b00011
// Logic Operations
`define ALU_OP_AND 5'b00100
`define ALU_OP_NAND 5'b00101
`define ALU_OP_OR 5'b00110
`define ALU_OP_NOR 5'b00111
`define ALU_OP_XOR 5'b01000
`define ALU_OP_XNOR 5'b01001
// Shift Operations
`define ALU_OP_SHL 5'b01010
`define ALU_OP_SHR 5'b01011
`define ALU_OP_ROL 5'b01100
`define ALU_OP_ROR 5'b01101
`define ALU_OP_ASR 5'b01110
// Comparation Operations
`define ALU_OP_CMP 5'b01111

module alu (
	input wire [4:0] op,
	input wire [15:0] a,
	input wire [15:0] b,
	input wire c_in,
	output reg [15:0] result,
	output reg [3:0] nzcv
	);
	
	always @(*)
	begin
		case (op)
			ALU_OP_ADD:
				result = a + b; //
			ALU_OP_SUB:
				result = a - b; //
			ALU_OP_MUL:
				result = a * b; //
			ALU_OP_DIV:
				result = a / b; //
			ALU_OP_AND:
				result = a & b;
			ALU_OP_NAND:
				result = ~(a & b);
			ALU_OP_OR:
				result = a | b;
			ALU_OP_NOR:
				result = ~(a | b);
			ALU_OP_XOR:
				result = a ^ b;
			ALU_OP_XNOR:
				result = ~(a ^ b);
			ALU_OP_SHL:
				result = a << 1;
			ALU_OP_SHR:
				result = a >> 1;
			ALU_OP_ROL:
				result = { a[6:0], a[7] };
			ALU_OP_ROR:
				result = { a[0], a[7:1] };
			ALU_OP_ASR:
				result = { a[7], a[7:0] };
			ALU_OP_CMP:
				result = a - b; //
			default:
		endcase
	end

endmodule
