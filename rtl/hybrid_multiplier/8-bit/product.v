module product(x1, x0, x2, one, two, sign, p, i, ca);
	input x1, x0, x2, sign, one, two;
	output p, i, ca;
	wire [2:0] k;
	xor xo1(i, x1, sign);
	and a1(k[1], i, one);
	and a0(k[0], x0, two);
	or o0(k[2], k[1], k[0]);
	xor xo2(p, k[2], x2);
	and a2(ca, k[2], x2);
endmodule