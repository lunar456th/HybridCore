// 1. 사용할 가산기, 승산기, 제산기, 쉬프터 import하기

/*
	Name		:	Arithmetic Logic Unit
	File		:	alu.v
	Word size	:	16-bit
	Operations	:	ADD, SUB, MUL, DIV, SHL, SHR, ROL, ROR, AND, OR, XOR, XNOR, NAND, NOR, CMP
	Adder		:	Kogge Stone Adder
	Multiplier	:	Fast Multiplier
	Divider		:	Fast Divider
	Shifter		:	Fast Shifter
*/

module alu (
	input wire [4:0] op,
	input wire [15:0] a,
	input wire [15:0] b,
	output reg [15:0] result,
	output reg [3:0] nzcv
	);
	
	// Arithmetic Operations
	parameter OP_ADD = 5'b00000;
	parameter OP_SUB = 5'b00001;
	parameter OP_MUL = 5'b00010;
	parameter OP_DIV = 5'b00011;
	// Logic Operations
	parameter OP_AND = 5'b00100;
	parameter OP_NAND = 5'b00101;
	parameter OP_OR = 5'b00110;
	parameter OP_NOR = 5'b00111;
	parameter OP_XOR = 5'b01000;
	parameter OP_XNOR = 5'b01001;
	// Shift Operations
	parameter OP_SHL = 5'b01010;
	parameter OP_SHR = 5'b01011;
	parameter OP_ROL = 5'b01100;
	parameter OP_ROR = 5'b01101;
	parameter OP_ASR = 5'b01110;
	// Comparation Operations
	parameter OP_CMP = 5'b01111;
	
	reg n, z, cout, v;
	
	always @(*)
	begin
		case (op)
			OP_ADD:
			begin
				adder adder(a, b, 0, result, cout);
				n <= result[15];
				z <= result == 0;
				c <= cout;
				v <= 0 //까먹음
			OP_SUB:
				adder adder(a, (~b) + 1, 1, result, cout); // 맞나?
				result = a - b; //
			OP_MUL:
				result = a * b; //
			OP_DIV:
				result = a / b; //
			OP_AND:
				result = a & b;
			OP_NAND:
				result = ~(a & b);
			OP_OR:
				result = a | b;
			OP_NOR:
				result = ~(a | b);
			OP_XOR:
				result = a ^ b;
			OP_XNOR:
				result = ~(a ^ b);
			OP_SHL:
				result = a << 1;
			OP_SHR:
				result = a >> 1;
			OP_ROL:
				result = { a[6:0], a[7] };
			OP_ROR:
				result = { a[0], a[7:1] };
			OP_ASR:
				result = { a[7], a[7:0] };
			OP_CMP:
				result = a - b; ///////////
			default:;
		endcase
	end

endmodule
