module hybrid_multiplier(x, y, p);
	input [15:0] x, y;
	output [31:0] p;
	wire [15:0] i1, j1, k1, l1, n1, o1, q1, r1;
	wire [15:0] i2, j2, k2, l2, n2, o2, q2, r2;
	wire [17:0] fp1, sp1, tp1, fop1;
	wire [17:0] fp2, sp2, tp2, fop2;
	wire [7:0] one, two, sign;
	wire [x:0] c0, ip0;
	wire [x:0] c1, ip1;
	wire [x:0] c2;
	wire [23:0] m;
	wire [7:0] cry, z;
	
	xor a1(z[0], one[0], two[0]);
	and a2(cry[0], z[0], sign[0]);
	xor a3(z[1], one[1], two[1]);
	and a4(cry[1], z[1], sign[1]);
	xor a5(z[2], one[2], two[2]);
	and a6(cry[2], z[2], sign[2]);
	xor a7(z[3], one[3], two[3]);
	and a8(cry[3], z[3], sign[3]);
	xor a9(z[4], one[4], two[4]);
	and a10(cry[4], z[4], sign[4]);
	xor a11(z[5], one[5], two[5]);
	and a12(cry[5], z[5], sign[5]);
	xor a13(z[6], one[6], two[6]);
	and a14(cry[6], z[6], sign[6])
	xor a15(z[7], one[7], two[7]);
	and a16(cry[7], z[7], sign[7]);
	
	code e1(one[0], two[0], sign[0], y[1], y[0], 1'b0);
	code e2(one[1], two[1], sign[1], y[3], y[2], y[1]);
	code e3(one[2], two[2], sign[2], y[5], y[4], y[3]);
	code e4(one[3], two[3], sign[3], y[7], y[6], y[5]);
	code e5(one[4], two[4], sign[4], y[9], y[8], y[7]);
	code e6(one[5], two[5], sign[5], y[11], y[10], y[9]);
	code e7(one[6], two[6], sign[6], y[13], y[12], y[11]);
	code e8(one[7], two[7], sign[7], y[15], y[14], y[13]);
	
	product p1(x[0], sign[0], cry[0], one[0], two[0], sign[0], fp[0], i1[0], n1[0]);
	product p2(x[1], i1[0], n1[0], one[0], two[0], sign[0], fp[1], i1[1], n1[1]);
	product p3(x[2], i1[1], n1[1], one[0], two[0], sign[0], fp[2], i1[2], n1[2]);
	product p4(x[3], i1[2], n1[2], one[0], two[0], sign[0], fp[3], i1[3], n1[3]);
	product p5(x[4], i1[3], n1[3], one[0], two[0], sign[0], fp[4], i1[4], n1[4]);
	product p6(x[5], i1[4], n1[4], one[0], two[0], sign[0], fp[5], i1[5], n1[5]);
	product p7(x[6], i1[5], n1[5], one[0], two[0], sign[0], fp[6], i1[6], n1[6]);
	product p8(x[7], i1[6], n1[6], one[0], two[0], sign[0], fp[7], i1[7], n1[7]);
	product p9(x[8], i1[7], n1[7], one[0], two[0], sign[0], fp[8], i1[8], n1[8]);
	product p10(x[9], i1[8], n1[8], one[0], two[0], sign[0], fp[9], i1[9], n1[9]);
	product p11(x[10], i1[9], n1[9], one[0], two[0], sign[0], fp[10], i1[10], n1[10]);
	product p12(x[11], i1[10], n1[10], one[0], two[0], sign[0], fp[11], i1[11], n1[11]);
	product p13(x[12], i1[11], n1[11], one[0], two[0], sign[0], fp[12], i1[12], n1[12]);
	product p14(x[13], i1[12], n1[12], one[0], two[0], sign[0], fp[13], i1[13], n1[13]);
	product p15(x[14], i1[13], n1[13], one[0], two[0], sign[0], fp[14], i1[14], n1[14]);
	product p16(x[15], i1[14], n1[14], one[0], two[0], sign[0], fp[15], i1[15], n1[15]);
	
	xor x1(m[0], i1[15], n1[15]);
	and x2(m[1], two[0], i1[15]);
	and x3(m[2], one[0], m[0]);
	or  x4(fp1[16], m[1], m[2]);
	not x5(fp1[17], fp1[16]);
	assign p[0] = fp1[0];
	
	product u1(x[0], sign[0], cry[0], one[0], two[0], sign[0], fp[0], j1[0], o1[0]);
	product u2(x[1], j1[0], o1[0], one[0], two[0], sign[0], fp[1], j1[1], o1[1]);
	product u3(x[2], j1[1], o1[1], one[0], two[0], sign[0], fp[2], j1[2], o1[2]);
	product u4(x[3], j1[2], o1[2], one[0], two[0], sign[0], fp[3], j1[3], o1[3]);
	product u5(x[4], j1[3], o1[3], one[0], two[0], sign[0], fp[4], j1[4], o1[4]);
	product u6(x[5], j1[4], o1[4], one[0], two[0], sign[0], fp[5], j1[5], o1[5]);
	product u7(x[6], j1[5], o1[5], one[0], two[0], sign[0], fp[6], j1[6], o1[6]);
	product u8(x[7], j1[6], o1[6], one[0], two[0], sign[0], fp[7], j1[7], o1[7]);
	product u9(x[8], j1[7], o1[7], one[0], two[0], sign[0], fp[8], j1[8], o1[8]);
	product u10(x[9], j1[8], o1[8], one[0], two[0], sign[0], fp[9], j1[9], o1[9]);
	product u11(x[10], j1[9], o1[9], one[0], two[0], sign[0], fp[10], j1[10], o1[10]);
	product u12(x[11], j1[10], o1[10], one[0], two[0], sign[0], fp[11], j1[11], o1[11]);
	product u13(x[12], j1[11], o1[11], one[0], two[0], sign[0], fp[12], j1[12], o1[12]);
	product u14(x[13], j1[12], o1[12], one[0], two[0], sign[0], fp[13], j1[13], o1[13]);
	product u15(x[14], j1[13], o1[13], one[0], two[0], sign[0], fp[14], j1[14], o1[14]);
	product u16(x[15], j1[14], o1[14], one[0], two[0], sign[0], fp[15], j1[15], o1[15]);
	
	xor x6(m[3], j1[15], o1[15]);
	and x7(m[4], two[0], j1[15]);
	and x8(m[5], one[0], m[0]);
	or  x9(sp1[16], m[4], m[5]);
	not x10(sp1[17], sp1[16]);
	assign p[0] = sp1[0];

	product s1(x[0], sign[0], cry[0], one[0], two[0], sign[0], fp[0], k1[0], q1[0]);
	product s2(x[1], k1[0], q1[0], one[0], two[0], sign[0], fp[1], k1[1], q1[1]);
	product s3(x[2], k1[1], q1[1], one[0], two[0], sign[0], fp[2], k1[2], q1[2]);
	product s4(x[3], k1[2], q1[2], one[0], two[0], sign[0], fp[3], k1[3], q1[3]);
	product s5(x[4], k1[3], q1[3], one[0], two[0], sign[0], fp[4], k1[4], q1[4]);
	product s6(x[5], k1[4], q1[4], one[0], two[0], sign[0], fp[5], k1[5], q1[5]);
	product s7(x[6], k1[5], q1[5], one[0], two[0], sign[0], fp[6], k1[6], q1[6]);
	product s8(x[7], k1[6], q1[6], one[0], two[0], sign[0], fp[7], k1[7], q1[7]);
	product s9(x[8], k1[7], q1[7], one[0], two[0], sign[0], fp[8], k1[8], q1[8]);
	product s10(x[9], k1[8], q1[8], one[0], two[0], sign[0], fp[9], k1[9], q1[9]);
	product s11(x[10], k1[9], q1[9], one[0], two[0], sign[0], fp[10], k1[10], q1[10]);
	product s12(x[11], k1[10], q1[10], one[0], two[0], sign[0], fp[11], k1[11], q1[11]);
	product s13(x[12], k1[11], q1[11], one[0], two[0], sign[0], fp[12], k1[12], q1[12]);
	product s14(x[13], k1[12], q1[12], one[0], two[0], sign[0], fp[13], k1[13], q1[13]);
	product s15(x[14], k1[13], q1[13], one[0], two[0], sign[0], fp[14], k1[14], q1[14]);
	product s16(x[15], k1[14], q1[14], one[0], two[0], sign[0], fp[15], k1[15], q1[15]);
	
	xor x11(m[6], k1[15], q1[15]);
	and x12(m[7], two[0], k1[15]);
	and x13(m[8], one[0], m[0]);
	or  x14(tp1[16], m[7], m[8]);
	not x15(tp1[17], tp1[16]);
	assign p[0] = tp1[0];

	product t1(x[0], sign[0], cry[0], one[0], two[0], sign[0], fp[0], l1[0], r1[0]);
	product t2(x[1], l1[0], r1[0], one[0], two[0], sign[0], fp[1], l1[1], r1[1]);
	product t3(x[2], l1[1], r1[1], one[0], two[0], sign[0], fp[2], l1[2], r1[2]);
	product t4(x[3], l1[2], r1[2], one[0], two[0], sign[0], fp[3], l1[3], r1[3]);
	product t5(x[4], l1[3], r1[3], one[0], two[0], sign[0], fp[4], l1[4], r1[4]);
	product t6(x[5], l1[4], r1[4], one[0], two[0], sign[0], fp[5], l1[5], r1[5]);
	product t7(x[6], l1[5], r1[5], one[0], two[0], sign[0], fp[6], l1[6], r1[6]);
	product t8(x[7], l1[6], r1[6], one[0], two[0], sign[0], fp[7], l1[7], r1[7]);
	product t9(x[8], l1[7], r1[7], one[0], two[0], sign[0], fp[8], l1[8], r1[8]);
	product t10(x[9], l1[8], r1[8], one[0], two[0], sign[0], fp[9], l1[9], r1[9]);
	product t11(x[10], l1[9], r1[9], one[0], two[0], sign[0], fp[10], l1[10], r1[10]);
	product t12(x[11], l1[10], r1[10], one[0], two[0], sign[0], fp[11], l1[11], r1[11]);
	product t13(x[12], l1[11], r1[11], one[0], two[0], sign[0], fp[12], l1[12], r1[12]);
	product t14(x[13], l1[12], r1[12], one[0], two[0], sign[0], fp[13], l1[13], r1[13]);
	product t15(x[14], l1[13], r1[13], one[0], two[0], sign[0], fp[14], l1[14], r1[14]);
	product t16(x[15], l1[14], r1[14], one[0], two[0], sign[0], fp[15], l1[15], r1[15]);
	
	xor x16(m[9], l1[15], r1[15]);
	and x17(m[10], two[0], l1[15]);
	and x18(m[11], one[0], m[0]);
	or  x19(fop1[16], m[10], m[11]);
	not x20(fop1[17], fop1[16]);
	assign p[0] = fop1[0];
	
	product pp1(x[0], sign[0], cry[0], one[0], two[0], sign[0], fp[0], i2[0], n2[0]);
	product pp2(x[1], i2[0], n2[0], one[0], two[0], sign[0], fp[1], i2[1], n2[1]);
	product pp3(x[2], i2[1], n2[1], one[0], two[0], sign[0], fp[2], i2[2], n2[2]);
	product pp4(x[3], i2[2], n2[2], one[0], two[0], sign[0], fp[3], i2[3], n2[3]);
	product pp5(x[4], i2[3], n2[3], one[0], two[0], sign[0], fp[4], i2[4], n2[4]);
	product pp6(x[5], i2[4], n2[4], one[0], two[0], sign[0], fp[5], i2[5], n2[5]);
	product pp7(x[6], i2[5], n2[5], one[0], two[0], sign[0], fp[6], i2[6], n2[6]);
	product pp8(x[7], i2[6], n2[6], one[0], two[0], sign[0], fp[7], i2[7], n2[7]);
	product pp9(x[8], i2[7], n2[7], one[0], two[0], sign[0], fp[8], i2[8], n2[8]);
	product pp10(x[9], i2[8], n2[8], one[0], two[0], sign[0], fp[9], i2[9], n2[9]);
	product pp11(x[10], i2[9], n2[9], one[0], two[0], sign[0], fp[10], i2[10], n2[10]);
	product pp12(x[11], i2[10], n2[10], one[0], two[0], sign[0], fp[11], i2[11], n2[11]);
	product pp13(x[12], i2[11], n2[11], one[0], two[0], sign[0], fp[12], i2[12], n2[12]);
	product pp14(x[13], i2[12], n2[12], one[0], two[0], sign[0], fp[13], i2[13], n2[13]);
	product pp15(x[14], i2[13], n2[13], one[0], two[0], sign[0], fp[14], i2[14], n2[14]);
	product pp16(x[15], i2[14], n2[14], one[0], two[0], sign[0], fp[15], i2[15], n2[15]);
	
	xor x21(m[12], i2[15], n2[15]);
	and x22(m[13], two[0], i2[15]);
	and x23(m[14], one[0], m[0]);
	or  x24(fp2[16], m[13], m[14]);
	not x25(fp2[17], fp2[16]);
	assign p[0] = fp2[0];
	
	product uu1(x[0], sign[0], cry[0], one[0], two[0], sign[0], fp[0], j2[0], o2[0]);
	product uu2(x[1], j2[0], o2[0], one[0], two[0], sign[0], fp[1], j2[1], o2[1]);
	product uu3(x[2], j2[1], o2[1], one[0], two[0], sign[0], fp[2], j2[2], o2[2]);
	product uu4(x[3], j2[2], o2[2], one[0], two[0], sign[0], fp[3], j2[3], o2[3]);
	product uu5(x[4], j2[3], o2[3], one[0], two[0], sign[0], fp[4], j2[4], o2[4]);
	product uu6(x[5], j2[4], o2[4], one[0], two[0], sign[0], fp[5], j2[5], o2[5]);
	product uu7(x[6], j2[5], o2[5], one[0], two[0], sign[0], fp[6], j2[6], o2[6]);
	product uu8(x[7], j2[6], o2[6], one[0], two[0], sign[0], fp[7], j2[7], o2[7]);
	product uu9(x[8], j2[7], o2[7], one[0], two[0], sign[0], fp[8], j2[8], o2[8]);
	product uu10(x[9], j2[8], o2[8], one[0], two[0], sign[0], fp[9], j2[9], o2[9]);
	product uu11(x[10], j2[9], o2[9], one[0], two[0], sign[0], fp[10], j2[10], o2[10]);
	product uu12(x[11], j2[10], o2[10], one[0], two[0], sign[0], fp[11], j2[11], o2[11]);
	product uu13(x[12], j2[11], o2[11], one[0], two[0], sign[0], fp[12], j2[12], o2[12]);
	product uu14(x[13], j2[12], o2[12], one[0], two[0], sign[0], fp[13], j2[13], o2[13]);
	product uu15(x[14], j2[13], o2[13], one[0], two[0], sign[0], fp[14], j2[14], o2[14]);
	product uu16(x[15], j2[14], o2[14], one[0], two[0], sign[0], fp[15], j2[15], o2[15]);
	
	xor x26(m[15], j2[15], o2[15]);
	and x27(m[16], two[0], j2[15]);
	and x28(m[17], one[0], m[0]);
	or  x29(sp2[16], m[16], m[17]);
	not x30(sp2[17], sp2[16]);
	assign p[0] = sp2[0];

	product ss1(x[0], sign[0], cry[0], one[0], two[0], sign[0], fp[0], k2[0], q2[0]);
	product ss2(x[1], k2[0], q2[0], one[0], two[0], sign[0], fp[1], k2[1], q2[1]);
	product ss3(x[2], k2[1], q2[1], one[0], two[0], sign[0], fp[2], k2[2], q2[2]);
	product ss4(x[3], k2[2], q2[2], one[0], two[0], sign[0], fp[3], k2[3], q2[3]);
	product ss5(x[4], k2[3], q2[3], one[0], two[0], sign[0], fp[4], k2[4], q2[4]);
	product ss6(x[5], k2[4], q2[4], one[0], two[0], sign[0], fp[5], k2[5], q2[5]);
	product ss7(x[6], k2[5], q2[5], one[0], two[0], sign[0], fp[6], k2[6], q2[6]);
	product ss8(x[7], k2[6], q2[6], one[0], two[0], sign[0], fp[7], k2[7], q2[7]);
	product ss9(x[8], k2[7], q2[7], one[0], two[0], sign[0], fp[8], k2[8], q2[8]);
	product ss10(x[9], k2[8], q2[8], one[0], two[0], sign[0], fp[9], k2[9], q2[9]);
	product ss11(x[10], k2[9], q2[9], one[0], two[0], sign[0], fp[10], k2[10], q2[10]);
	product ss12(x[11], k2[10], q2[10], one[0], two[0], sign[0], fp[11], k2[11], q2[11]);
	product ss13(x[12], k2[11], q2[11], one[0], two[0], sign[0], fp[12], k2[12], q2[12]);
	product ss14(x[13], k2[12], q2[12], one[0], two[0], sign[0], fp[13], k2[13], q2[13]);
	product ss15(x[14], k2[13], q2[13], one[0], two[0], sign[0], fp[14], k2[14], q2[14]);
	product ss16(x[15], k2[14], q2[14], one[0], two[0], sign[0], fp[15], k2[15], q2[15]);
	
	xor x31(m[18], k2[15], q2[15]);
	and x32(m[19], two[0], k2[15]);
	and x33(m[20], one[0], m[0]);
	or  x34(tp2[16], m[19], m[20]);
	not x35(tp2[17], tp2[16]);
	assign p[0] = tp2[0];

	product tt1(x[0], sign[0], cry[0], one[0], two[0], sign[0], fp[0], l2[0], r2[0]);
	product tt2(x[1], l2[0], r2[0], one[0], two[0], sign[0], fp[1], l2[1], r2[1]);
	product tt3(x[2], l2[1], r2[1], one[0], two[0], sign[0], fp[2], l2[2], r2[2]);
	product tt4(x[3], l2[2], r2[2], one[0], two[0], sign[0], fp[3], l2[3], r2[3]);
	product tt5(x[4], l2[3], r2[3], one[0], two[0], sign[0], fp[4], l2[4], r2[4]);
	product tt6(x[5], l2[4], r2[4], one[0], two[0], sign[0], fp[5], l2[5], r2[5]);
	product tt7(x[6], l2[5], r2[5], one[0], two[0], sign[0], fp[6], l2[6], r2[6]);
	product tt8(x[7], l2[6], r2[6], one[0], two[0], sign[0], fp[7], l2[7], r2[7]);
	product tt9(x[8], l2[7], r2[7], one[0], two[0], sign[0], fp[8], l2[8], r2[8]);
	product tt10(x[9], l2[8], r2[8], one[0], two[0], sign[0], fp[9], l2[9], r2[9]);
	product tt11(x[10], l2[9], r2[9], one[0], two[0], sign[0], fp[10], l2[10], r2[10]);
	product tt12(x[11], l2[10], r2[10], one[0], two[0], sign[0], fp[11], l2[11], r2[11]);
	product tt13(x[12], l2[11], r2[11], one[0], two[0], sign[0], fp[12], l2[12], r2[12]);
	product tt14(x[13], l2[12], r2[12], one[0], two[0], sign[0], fp[13], l2[13], r2[13]);
	product tt15(x[14], l2[13], r2[13], one[0], two[0], sign[0], fp[14], l2[14], r2[14]);
	product tt16(x[15], l2[14], r2[14], one[0], two[0], sign[0], fp[15], l2[15], r2[15]);
	
	xor x36(m[21], l2[15], r2[15]);
	and x37(m[22], two[0], l2[15]);
	and x38(m[23], one[0], m[0]);
	or  x39(tr1[16], m[22], m[23]);
	not x40(tr1[17], tr1[16]);
	assign p[0] = tr1[0];

	//
	
	