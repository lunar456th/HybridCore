`default_nettype none
	
module ksa_top (
	input wire [15:0] a,
	input wire [15:0] b,
	input wire c_in,
	output wire [15:0] s,
	output wire c_out
	);
	
	wire [15:0] p1;
	wire [15:0] g1;
	wire c1;
	
	wire [14:0] p2;
	wire [15:0] g2;
	wire c2;
	wire [15:0] ps1;
	
	wire [12:0] p3;
	wire [15:0] g3;
	wire c3;
	wire [15:0] ps2;
	
	wire [8:0] p4;
	wire [15:0] g4;
	wire c4;
	wire [15:0] ps3;
	
	wire [15:0] p5;
	wire [15:0] g5;
	wire c5;
	
	ks_1 s1(c_in, a, b, p1, g1, c1);
	ks_2 s2(c1, p1, g1, c2, p2, g2, ps1);
	ks_3 s3(c2, p2, g2, ps1, c3, p3, g3, ps2);
	ks_4 s4(c3, p3, g3, ps2, c4, p4, g4, ps3);
	ks_5 s5(c4, p4, g4, ps3, c5, p5, g5);
	ks_6 s6(c5, p5, g5, s, c_out);
	
endmodule
