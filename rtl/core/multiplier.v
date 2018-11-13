/*
	Name		:	Multiplier
	File		:	multiplier.v
	Word size	:	16-bit
	Algorithm	:	Karatsuba
	Url			:	https://github.com/jeremytregunna/ksa
*/

`include "defines.v"

module multiplier(
	input wire [15:0] D,
	input wire [15:0] E,
	output wire [31:0] F
	);
	
	wire [7:0] lev_1[3:0];
	wire [15:0] lev_2[1:0];
	wire [8:0] temporary_1[1:0];
	wire [17:0] temporary_2;
	wire [17:0] temporary_3;
	wire [31:0] shifted16_16;
	wire [25:0] shifted16_8;
	reg [3:0] l_1[3:0];
	reg [7:0] l_2[1:0];
	reg [4:0] temp_1[1:0];
	reg [9:0] temp_2;
	reg [9:0] temp_3;
	reg [15:0] shift8_8;
	reg [13:0] shift8_4;
	reg [3:0] l9_1[3:0];
	reg [7:0] l9_2[1:0];
	reg [4:0] temp9_1[1:0];
	reg [9:0] temp9_2;
	reg [9:0] temp9_3;
	reg [15:0] shift9_8;
	reg [13:0] shift9_4;
	reg [3:0] ac, bd;
	reg [2:0] add_aPb, add_cPd;
	reg [4:0] add_ac_bd;
	reg [5:0] mul_p;
	reg [7:0] shift_4;
	reg [7:0] shift_2;
	reg [5:0] ac5;
	reg [3:0] bd5;
	reg [3:0] add_aPb5, add_cPd5;
	reg [7:0] mul_p5;
	reg [8:0] shift_4_5;
	reg [9:0] shift_2_5;
	
	assign lev_1[0] = D[15:8];
	assign lev_1[1] = D[7:0];
	assign lev_1[2] = E[15:8];
	assign lev_1[3] = E[7:0];
	assign lev_2[0] = karat8(lev_1[0], lev_1[2]);
	assign lev_2[1] = karat8(lev_1[1], lev_1[3]);
    assign temporary_1[0] = lev_1[0] + lev_1[1];
	assign temporary_1[1] = lev_1[2] + lev_1[3];
	assign temporary_2 = karat9(temporary_1[0], temporary_1[1]);
	assign temporary_3 = temporary_2 - (lev_2[0] + lev_2[1]); 
	assign shifted16_16 = lev_2[0]<<16;
	assign shifted16_8 = temporary_3<<8;
	assign F = shifted16_16 + shifted16_8 + lev_2[1];
		
	function [15:0] karat8 (
		input wire [7:0] P,
		input wire [7:0] Q
		);
		begin
			l_1[0] = P[7:4];
			l_1[1] = P[3:0];
			l_1[2] = Q[7:4];
			l_1[3] = Q[3:0];
			l_2[0] = karat4(l_1[0], l_1[2]);
			l_2[1] = karat4(l_1[1], l_1[3]);
			temp_1[0] = l_1[0] + l_1[1];
			temp_1[1] = l_1[2] + l_1[3];
			temp_2 = karat5(temp_1[0], temp_1[1]);
			temp_3 = temp_2 - (l_2[0] + l_2[1]); 
			shift8_8 = l_2[0]<<8;
			shift8_4 = temp_3<<4;
			karat8 = shift8_8 + shift8_4 + l_2[1];
		end

	endfunction
	
	function [17:0] karat9(
		input wire [8:0] P,
		input wire [8:0] Q
		);
		begin
			l9_1[0] = P[8:4];
			l9_1[1] = P[3:0];
			l9_1[2] = Q[8:4];
			l9_1[3] = Q[3:0];
			l9_2[0] = karat5(l9_1[0], l9_1[2]);
			l9_2[1] = karat5(l9_1[1], l9_1[3]);
			temp9_1[0] = l9_1[0] + l9_1[1];
			temp9_1[1] = l9_1[2] + l9_1[3];
			temp9_2 = karat5(temp9_1[0], temp9_1[1]);
			temp9_3 = temp9_2 - (l9_2[0] + l9_2[1]); 
			shift9_8 = l9_2[0]<<8;
			shift9_4 = temp9_3<<4;
			karat9 = shift9_8 + shift9_4 + l9_2[1];
		end

	endfunction
	
	function [7:0] karat4 (
		input wire [3:0] X,
		input wire [3:0] Y
		);
		begin
			ac = mult2(X[3:2], Y[3:2]);
			bd = mult2(X[1:0], Y[1:0]);
			add_aPb = X[1:0] + X[3:2];
			add_cPd = Y[1:0] + Y[3:2];
			mul_p = mult3(add_aPb, add_cPd);
			shift_4 = ac<<4;
			shift_2 = (mul_p - ac - bd)<<2;
			karat4 = shift_4 + shift_2 + bd;
		end
	
	endfunction

	function [9:0] karat5 (
		input wire [4:0] A,
		input wire [4:0] B
		);
		begin
			ac5 = mult3(A[4:2], B[4:2]);
			bd5 = mult2(A[1:0], B[1:0]);
			add_aPb5 = A[1:0] + A[4:2];
			add_cPd5 = B[1:0] + B[4:2];
			mul_p5 = mult4_5(add_aPb5, add_cPd5);
			shift_4_5 = ac5<<4;
			shift_2_5 = (mul_p5 - (ac5 + bd5))<<2;
			karat5 = shift_4_5 + shift_2_5 + bd5;
		end
	
	endfunction

	function [3:0] mult2(input wire [1:0] M, input wire [1:0] N);
		mult2 = M * N[0] + (M << 1) * N[1];
	endfunction

	function [5:0] mult3(input wire [2:0] M, input wire [2:0] N);
		mult3 = M * N[0] + (M << 1) * N[1] + (M << 2) * N[2];
	endfunction
	
	function [5:0] mult4_5(input wire [3:0] M_5, input wire [3:0] N_5);
		mult4_5 = M_5 * N_5[0] + (M_5 << 1)* N_5[1] + (M_5 << 2) * N_5[2] + (M_5 << 3) * N_5[3];
	endfunction
	
endmodule
