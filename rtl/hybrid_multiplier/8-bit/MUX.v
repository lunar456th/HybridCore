module MUX(i0, i1, s, o);
	input i0, i1, s;
	output o;
	wire t, p, q;
	and a1(t, s, i1);
	not n0(p, s);
	and a2(q, p, i0);
	or a3(o, t, q);
endmodule