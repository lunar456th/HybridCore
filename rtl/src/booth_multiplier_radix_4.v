`timescale 1ns / 1ps

module Booth_Multiplier_4xA #(parameter N = 64) ( 
	input Rst, 
	input Clk, 

	input Ld, 
	input [(N - 1):0] M, 
	input [(N - 1):0] R, 
	output reg Valid, 
	output reg [((2 * N) - 1):0] P 
	);
	
	localparam pNumCycles = ((N + 1) / 4); 
	reg [4:0] Cntr; 
	reg [4:0] Booth; 
	reg Guard; 
	reg [(N + 3):0] A; 
	wire [(N + 3):0] Mx8, Mx4, Mx2, Mx1; 
	reg PnM_B, M_Sel_B, En_B; 
	reg PnM_C, M_Sel_C, En_C; 
	wire [(N + 3):0] Hi; 
	reg [(N + 3):0] B, C; 
	reg Ci_B, Ci_C; 
	wire [(N + 3):0] T, S; 
	reg [((2 * N) + 3):0] Prod; 
	
	always @(posedge Clk)
	begin
		if(Rst)
			Cntr <= #1 0;
		else if(Ld)
			Cntr <= #1 pNumCycles;
		else if(|Cntr)
			Cntr <= #1 (Cntr - 1);
	end
	
	always @(posedge Clk)
	begin
		if(Rst)
			A <= #1 0;
		else if(Ld)
			A <= #1 { { 4{ M[(N - 1)] } }, M };
	end
	
	assign Mx8 = { A, 3'b0 };
	assign Mx4 = { A, 2'b0 };
	assign Mx2 = { A, 1'b0 };
	assign Mx1 = A;

	always @ (*)
	begin
		Booth <= { Prod[3:0], Guard }; 
	end

	assign Hi = Prod[((2 * N) + 3):N]; 
	
	always @(*)
	begin
		case(Booth)
			5'b00000 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			5'b00001 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			5'b00010 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			5'b00011 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			5'b00100 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			5'b00101 : { PnM_B, M_Sel_B, En_B } <= 3'b001; 
			5'b00110 : { PnM_B, M_Sel_B, En_B } <= 3'b001; 
			5'b00111 : { PnM_B, M_Sel_B, En_B } <= 3'b001; 
			5'b01000 : { PnM_B, M_Sel_B, En_B } <= 3'b001; 
			5'b01001 : { PnM_B, M_Sel_B, En_B } <= 3'b001; 
			5'b01010 : { PnM_B, M_Sel_B, En_B } <= 3'b001; 
			5'b01011 : { PnM_B, M_Sel_B, En_B } <= 3'b001; 
			5'b01100 : { PnM_B, M_Sel_B, En_B } <= 3'b001; 
			5'b01101 : { PnM_B, M_Sel_B, En_B } <= 3'b011; 
			5'b01110 : { PnM_B, M_Sel_B, En_B } <= 3'b011; 
			5'b01111 : { PnM_B, M_Sel_B, En_B } <= 3'b011; 
			5'b10000 : { PnM_B, M_Sel_B, En_B } <= 3'b111; 
			5'b10001 : { PnM_B, M_Sel_B, En_B } <= 3'b111; 
			5'b10010 : { PnM_B, M_Sel_B, En_B } <= 3'b111; 
			5'b10011 : { PnM_B, M_Sel_B, En_B } <= 3'b101; 
			5'b10100 : { PnM_B, M_Sel_B, En_B } <= 3'b101; 
			5'b10101 : { PnM_B, M_Sel_B, En_B } <= 3'b101; 
			5'b10110 : { PnM_B, M_Sel_B, En_B } <= 3'b101; 
			5'b10111 : { PnM_B, M_Sel_B, En_B } <= 3'b101; 
			5'b11000 : { PnM_B, M_Sel_B, En_B } <= 3'b101; 
			5'b11001 : { PnM_B, M_Sel_B, En_B } <= 3'b101; 
			5'b11010 : { PnM_B, M_Sel_B, En_B } <= 3'b101; 
			5'b11011 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			5'b11100 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			5'b11101 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			5'b11110 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			5'b11111 : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
			default  : { PnM_B, M_Sel_B, En_B } <= 3'b000; 
		endcase
	end
	
	always @(*)
	begin
		case(Booth)
			5'b00000 : { PnM_C, M_Sel_C, En_C } <= 3'b000; 
			5'b00001 : { PnM_C, M_Sel_C, En_C } <= 3'b001; 
			5'b00010 : { PnM_C, M_Sel_C, En_C } <= 3'b001; 
			5'b00011 : { PnM_C, M_Sel_C, En_C } <= 3'b011; 
			5'b00100 : { PnM_C, M_Sel_C, En_C } <= 3'b011; 
			5'b00101 : { PnM_C, M_Sel_C, En_C } <= 3'b101; 
			5'b00110 : { PnM_C, M_Sel_C, En_C } <= 3'b101; 
			5'b00111 : { PnM_C, M_Sel_C, En_C } <= 3'b000; 
			5'b01000 : { PnM_C, M_Sel_C, En_C } <= 3'b000; 
			5'b01001 : { PnM_C, M_Sel_C, En_C } <= 3'b001; 
			5'b01010 : { PnM_C, M_Sel_C, En_C } <= 3'b001; 
			5'b01011 : { PnM_C, M_Sel_C, En_C } <= 3'b011; 
			5'b01100 : { PnM_C, M_Sel_C, En_C } <= 3'b011; 
			5'b01101 : { PnM_C, M_Sel_C, En_C } <= 3'b101; 
			5'b01110 : { PnM_C, M_Sel_C, En_C } <= 3'b101; 
			5'b01111 : { PnM_C, M_Sel_C, En_C } <= 3'b000; 
			5'b10000 : { PnM_C, M_Sel_C, En_C } <= 3'b000; 
			5'b10001 : { PnM_C, M_Sel_C, En_C } <= 3'b001; 
			5'b10010 : { PnM_C, M_Sel_C, En_C } <= 3'b001; 
			5'b10011 : { PnM_C, M_Sel_C, En_C } <= 3'b111; 
			5'b10100 : { PnM_C, M_Sel_C, En_C } <= 3'b111; 
			5'b10101 : { PnM_C, M_Sel_C, En_C } <= 3'b101; 
			5'b10110 : { PnM_C, M_Sel_C, En_C } <= 3'b101; 
			5'b10111 : { PnM_C, M_Sel_C, En_C } <= 3'b000; 
			5'b11000 : { PnM_C, M_Sel_C, En_C } <= 3'b000; 
			5'b11001 : { PnM_C, M_Sel_C, En_C } <= 3'b001; 
			5'b11010 : { PnM_C, M_Sel_C, En_C } <= 3'b001; 
			5'b11011 : { PnM_C, M_Sel_C, En_C } <= 3'b111; 
			5'b11100 : { PnM_C, M_Sel_C, En_C } <= 3'b111; 
			5'b11101 : { PnM_C, M_Sel_C, En_C } <= 3'b101; 
			5'b11110 : { PnM_C, M_Sel_C, En_C } <= 3'b101; 
			5'b11111 : { PnM_C, M_Sel_C, En_C } <= 3'b000; 
			default  : { PnM_C, M_Sel_C, En_C } <= 3'b000; 
		endcase
	end
	
	always @(*)
	begin
		case({ PnM_B, M_Sel_B, En_B })
			3'b001  : { Ci_B, B } <= { 1'b0, Mx4 };
			3'b011  : { Ci_B, B } <= { 1'b0, Mx8 };
			3'b101  : { Ci_B, B } <= { 1'b1, ~Mx4 };
			3'b111  : { Ci_B, B } <= { 1'b1, ~Mx8 };
			default : { Ci_B, B } <= 0;
		endcase
	end
	
	always @(*)
	begin
		case({ PnM_C, M_Sel_C, En_C })
			3'b001  : { Ci_C, C } <= { 1'b0, Mx1 };
			3'b011  : { Ci_C, C } <= { 1'b0, Mx2 };
			3'b101  : { Ci_C, C } <= { 1'b1, ~Mx1 };
			3'b111  : { Ci_C, C } <= { 1'b1, ~Mx2 };
			default : { Ci_C, C } <= 0;
		endcase
	end
	
	assign T = Hi + B + Ci_B;
	assign S = T + C + Ci_C;
	
	always @(posedge Clk)
	begin
		if(Rst)
			Prod <= #1 0;
		else if(Ld)
			Prod <= #1 R;
		else if(|Cntr) 
			Prod <= #1 { { 4{ S[(N + 3)] } }, S, Prod[(N - 1):4] };
	end
	
	always @(posedge Clk)
	begin
		if(Rst)
			Guard <= #1 0;
		else if(Ld)
			Guard <= #1 0;
		else if(|Cntr)
			Guard <= #1 Prod[3];
	end
	
	always @(posedge Clk)
	begin
		if(Rst)
			P <= #1 0;
		else if(Cntr == 1)
			P <= #1 { S, Prod[(N - 1):4] };
	end
	
	always @(posedge Clk)
	begin
		if(Rst)
			Valid <= #1 0;
		else
			Valid <= #1 (Cntr == 1);
	end
	
endmodule