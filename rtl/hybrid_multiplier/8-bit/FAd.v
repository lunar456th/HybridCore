module FAd(a, b, c, cy, sm);
	input a, b, c;
	output cy, sm;
	wire x, y;
	xor x1(x, a, b);
	xnor x2(y, a, b);
	MUX m1(x, y, c, sm);
	MUX m2(a, c, x, cy);
endmodule