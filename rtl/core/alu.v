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

`include "defines.v"

module alu (
	input wire [4:0] op,
	input wire [15:0] a,
	input wire [15:0] b,
	output reg [15:0] result,
	output reg [3:0] nzcv
	);
	
	reg n, z, c_out, v, c_out_prev;
	wire [31:0] result_mul_div;
	
	always @(*)
	begin
		case (op)
			OP_ADD:
			begin
				adder adder(a, b, 1'b0, result, c_out, c_out_prev);
				n <= result[15];
				z <= result == 0;
				c <= c_out;
				v <= c_out ^ c_out_prev; ///
			end
			OP_SUB:
			OP_CMP:
			begin
				adder adder(a, (~b) + 16'd1, 1'b1, result, c_out, c_out_prev);
				n <= result[15];
				z <= result == 0;
				c <= c_out;
				v <= c_out ^ c_out_prev; ///
			end
			OP_MUL:
				multiplier multiplier(a, b, result_mul_div); // always 안에서 모듈을 부를 수 있나???
				result <= result_mul_div[15:0];
			OP_DIV:
				divider divider(a, b, result_mul_div); // always 안에서 모듈을 부를 수 있나???
				result <= result_mul_div[15:0];
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
			default:;
		endcase
	end

endmodule
