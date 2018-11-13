module FA(a, b, c, cy, sm);
	input a, b, c;
	output cy, sm;
	wire x, y, z;
	xor x1(x, a, b);
	xor x2(sm, x, c);
	and a1(y, a, b);
	and a2(z, x, c);
	or o1(cy, y, z);
endmodule
