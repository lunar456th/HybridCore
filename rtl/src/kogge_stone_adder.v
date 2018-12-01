module KSA64 (
	input wire [63:0] a,
	input wire [63:0] b,
	output wire [63:0] sum,
	output wire cout
	);

	wire cin = 1'b0;
	wire [63:0] c;
	wire [63:0] g, p;
	Square sq[63:0](g, p, a, b);

	// first line of circles
	wire [63:1] g2, p2;
	SmallCircle sc0_0(c[0], g[0]);
	BigCircle bc0[63:1](g2[63:1], p2[63:1], g[63:1], p[63:1], g[62:0], p[62:0]);

	// second line of circles
	wire [63:3] g3, p3;
	SmallCircle sc1[2:1](c[2:1], g2[2:1]);
	BigCircle bc1[63:3](g3[63:3], p3[63:3], g2[63:3], p2[63:3], g2[61:1], p2[61:1]);

	// third line of circles
	wire [63:7] g4, p4;
	SmallCircle sc2[6:3](c[6:3], g3[6:3]);
	BigCircle bc2[63:7](g4[63:7], p4[63:7], g3[63:7], p3[63:7], g3[59:3], p3[59:3]);

	// fourth line of circles
	wire [63:15] g5, p5;
	SmallCircle sc3[14:7](c[14:7], g4[14:7]);
	BigCircle bc3[63:15](g5[63:15], p5[63:15], g4[63:15], p4[63:15], g4[55:7], p4[55:7]);

	// fifth line of circles
	wire [63:31] g6, p6;
	SmallCircle sc4[30:15](c[30:15], g5[30:15]);
	BigCircle bc4[63:31](g6[63:31], p6[63:31], g5[63:31], p5[63:31], g5[47:15], p5[47:15]);

	// sixth line of circles
	wire [63:63] g7, p7;
	SmallCircle sc5[62:31](c[62:31], g6[62:31]);  
	BigCircle bc4_63(g7[63], p7[63], g6[63], p6[63], g6[31], p6[31]);

	// seventh line of circles
	SmallCircle sc6(c[63], g7[63]);  

	// last line - triangles
	Triangle tr0(sum[0], p[0], cin);
	Triangle tr[63:1](sum[63:1], p[63:1], c[62:0]);

	// generate cout
	buf #(1) (cout, c[63]);

endmodule

module Square (
	input wire Ai,
	input wire Bi,
	output wire G,
	output wire P
	);

	and #(1) (G, Ai, Bi);
	xor #(2) (P, Ai, Bi);

endmodule

module SmallCircle (
	input wire Gi,
	output wire Ci
	);

	buf #(1) (Ci, Gi);

endmodule

module BigCircle (
	input wire Gi,
	input wire Pi,
	input wire GiPrev,
	input wire PiPrev,
	output wire G,
	output wire P
	);

	wire e;
	and #(1) (e, Pi, GiPrev);
	or #(1) (G, e, Gi);
	and #(1) (P, Pi, PiPrev);

endmodule

module Triangle (
	input wire Pi,
	input wire CiPrev,
	output wire Si
	);

	xor #(2) (Si, Pi, CiPrev);

endmodule
