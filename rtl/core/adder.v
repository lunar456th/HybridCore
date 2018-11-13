/*
	Name		:	Adder
	File		:	adder.v
	Word size	:	16-bit
	Algorithm	:	kogge Stone Adder
	Url			:	https://github.com/jeremytregunna/ksa
*/

`include "defines.v"

module adder (
	input wire [15:0] a,
	input wire [15:0] b,
	input wire c_in,
	output wire [15:0] s,
	output wire c_out
	output wire c_out_prev;
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
	assign c_out_prev = c5; ///// 얘가 c-1이 맞는지..
endmodule

module pg (
	input wire i_a,
	input wire i_b,
	output wire o_p,
	output wire o_g
	);
	assign o_p = i_a ^ i_b;
	assign o_g = i_a & i_b;
endmodule

module black (
	input wire i_pj,
	input wire i_gj,
	input wire i_pk,
	input wire i_gk,
	output wire o_g,
	output wire o_p
	);
	assign o_g = i_gk | (i_gj & i_pk);
	assign o_p = i_pk & i_pj;
endmodule

module grey (
	input wire i_gj,
	input wire i_pk,
	input wire i_gk,
	output wire o_g
	);
	assign o_g = i_gk | (i_gj & i_pk);
endmodule

module ks_1 (
	input wire i_c0,
	input wire [15:0]i_a,
	input wire [15:0]i_b,
	output wire [15:0]o_pk_1,
	output wire [15:0]o_gk_1,
	output wire o_c0_1
	);
	assign o_c0_1 = i_c0;
	pg pg_0(i_a[0], i_b[0], o_pk_1[0], o_gk_1[0]);
	pg pg_1(i_a[1], i_b[1], o_pk_1[1], o_gk_1[1]);
	pg pg_2(i_a[2], i_b[2], o_pk_1[2], o_gk_1[2]);
	pg pg_3(i_a[3], i_b[3], o_pk_1[3], o_gk_1[3]);
	pg pg_4(i_a[4], i_b[4], o_pk_1[4], o_gk_1[4]);
	pg pg_5(i_a[5], i_b[5], o_pk_1[5], o_gk_1[5]);
	pg pg_6(i_a[6], i_b[6], o_pk_1[6], o_gk_1[6]);
	pg pg_7(i_a[7], i_b[7], o_pk_1[7], o_gk_1[7]);
	pg pg_8(i_a[8], i_b[8], o_pk_1[8], o_gk_1[8]);
	pg pg_9(i_a[9], i_b[9], o_pk_1[9], o_gk_1[9]);
	pg pg_10(i_a[10], i_b[10], o_pk_1[10], o_gk_1[10]);
	pg pg_11(i_a[11], i_b[11], o_pk_1[11], o_gk_1[11]);
	pg pg_12(i_a[12], i_b[12], o_pk_1[12], o_gk_1[12]);
	pg pg_13(i_a[13], i_b[13], o_pk_1[13], o_gk_1[13]);
	pg pg_14(i_a[14], i_b[14], o_pk_1[14], o_gk_1[14]);
	pg pg_15(i_a[15], i_b[15], o_pk_1[15], o_gk_1[15]);
endmodule

module ks_2 (
	input wire i_c0,
	input wire [15:0] i_pk,
	input wire [15:0] i_gk,
	output wire o_c0,
	output wire [14:0] o_pk,
	output wire [15:0] o_gk,
	output wire [15:0] o_p_save
	);
	wire [15:0] gkj;
	wire [14:0] pkj;
	assign o_c0 = i_c0;
	assign o_p_save = i_pk[15:0];
	assign gkj[0] = i_c0;
	assign gkj[15:1] = i_gk[14:0];
	assign pkj = i_pk[14:0];
	grey gc_0(gkj[0], i_pk[0], i_gk[0], o_gk[0]);
	black bc_0(pkj[0], gkj[1], i_pk[1], i_gk[1], o_gk[1], o_pk[0]);
	black bc_1(pkj[1], gkj[2], i_pk[2], i_gk[2], o_gk[2], o_pk[1]);
	black bc_2(pkj[2], gkj[3], i_pk[3], i_gk[3], o_gk[3], o_pk[2]);
	black bc_3(pkj[3], gkj[4], i_pk[4], i_gk[4], o_gk[4], o_pk[3]);
	black bc_4(pkj[4], gkj[5], i_pk[5], i_gk[5], o_gk[5], o_pk[4]);
	black bc_5(pkj[5], gkj[6], i_pk[6], i_gk[6], o_gk[6], o_pk[5]);
	black bc_6(pkj[6], gkj[7], i_pk[7], i_gk[7], o_gk[7], o_pk[6]);
	black bc_7(pkj[7], gkj[8], i_pk[8], i_gk[8], o_gk[8], o_pk[7]);
	black bc_8(pkj[8], gkj[9], i_pk[9], i_gk[9], o_gk[9], o_pk[8]);
	black bc_9(pkj[9], gkj[10], i_pk[10], i_gk[10], o_gk[10], o_pk[9]);
	black bc_10(pkj[10], gkj[11], i_pk[11], i_gk[11], o_gk[11], o_pk[10]);
	black bc_11(pkj[11], gkj[12], i_pk[12], i_gk[12], o_gk[12], o_pk[11]);
	black bc_12(pkj[12], gkj[13], i_pk[13], i_gk[13], o_gk[13], o_pk[12]);
	black bc_13(pkj[13], gkj[14], i_pk[14], i_gk[14], o_gk[14], o_pk[13]);
	black bc_14(pkj[14], gkj[15], i_pk[15], i_gk[15], o_gk[15], o_pk[14]);
endmodule

module ks_3 (
	input wire i_c0,
	input wire [14:0] i_pk,
	input wire [15:0] i_gk,
	input wire [15:0] i_p_save,
	output wire o_c0,
	output wire [12:0] o_pk,
	output wire [15:0] o_gk,
	output wire [15:0] o_p_save
	);
	wire [14:0] gkj;
	wire [12:0] pkj;
	assign o_c0 = i_c0;
	assign o_p_save = i_p_save[15:0];
	assign gkj[0] = i_c0;
	assign gkj[14:1] = i_gk[13:0];
	assign pkj = i_pk[12:0];
	assign o_gk[0] = i_gk[0];
	grey gc_0(gkj[0], i_pk[0], i_gk[1], o_gk[1]);
	grey gc_1(gkj[1], i_pk[1], i_gk[2], o_gk[2]);
	black bc_0(pkj[0], gkj[2], i_pk[2], i_gk[3], o_gk[3], o_pk[0]);
	black bc_1(pkj[1], gkj[3], i_pk[3], i_gk[4], o_gk[4], o_pk[1]);
	black bc_2(pkj[2], gkj[4], i_pk[4], i_gk[5], o_gk[5], o_pk[2]);
	black bc_3(pkj[3], gkj[5], i_pk[5], i_gk[6], o_gk[6], o_pk[3]);
	black bc_4(pkj[4], gkj[6], i_pk[6], i_gk[7], o_gk[7], o_pk[4]);
	black bc_5(pkj[5], gkj[7], i_pk[7], i_gk[8], o_gk[8], o_pk[5]);
	black bc_6(pkj[6], gkj[8], i_pk[8], i_gk[9], o_gk[9], o_pk[6]);
	black bc_7(pkj[7], gkj[9], i_pk[9], i_gk[10], o_gk[10], o_pk[7]);
	black bc_8(pkj[8], gkj[10], i_pk[10], i_gk[11], o_gk[11], o_pk[8]);
	black bc_9(pkj[9], gkj[11], i_pk[11], i_gk[12], o_gk[12], o_pk[9]);
	black bc_10(pkj[10], gkj[12], i_pk[12], i_gk[13], o_gk[13], o_pk[10]);
	black bc_11(pkj[11], gkj[13], i_pk[13], i_gk[14], o_gk[14], o_pk[11]);
	black bc_12(pkj[12], gkj[14], i_pk[14], i_gk[15], o_gk[15], o_pk[12]);
endmodule

module ks_4 (
	input wire i_c0,
	input wire [12:0] i_pk,
	input wire [15:0] i_gk,
	input wire [15:0] i_p_save,
	output wire o_c0,
	output wire [8:0] o_pk,
	output wire [15:0] o_gk,
	output wire [15:0] o_p_save
	);
	wire [12:0] gkj;
	wire [8:0] pkj;
	assign o_c0 = i_c0;
	assign o_p_save = i_p_save[15:0];
	assign gkj[0] = i_c0;
	assign gkj[12:1] = i_gk[11:0];
	assign pkj = i_pk[8:0];
	assign o_gk[2:0] = i_gk[2:0];
	grey gc_0(gkj[0], i_pk[0], i_gk[3], o_gk[3]);
	grey gc_1(gkj[1], i_pk[1], i_gk[4], o_gk[4]);
	grey gc_2(gkj[2], i_pk[2], i_gk[5], o_gk[5]);
	grey gc_3(gkj[3], i_pk[3], i_gk[6], o_gk[6]);
	black bc_0(pkj[0], gkj[4], i_pk[4], i_gk[7], o_gk[7], o_pk[0]);
	black bc_1(pkj[1], gkj[5], i_pk[5], i_gk[8], o_gk[8], o_pk[1]);
	black bc_2(pkj[2], gkj[6], i_pk[6], i_gk[9], o_gk[9], o_pk[2]);
	black bc_3(pkj[3], gkj[7], i_pk[7], i_gk[10], o_gk[10], o_pk[3]);
	black bc_4(pkj[4], gkj[8], i_pk[8], i_gk[11], o_gk[11], o_pk[4]);
	black bc_5(pkj[5], gkj[9], i_pk[9], i_gk[12], o_gk[12], o_pk[5]);
	black bc_6(pkj[6], gkj[10], i_pk[10], i_gk[13], o_gk[13], o_pk[6]);
	black bc_7(pkj[7], gkj[11], i_pk[11], i_gk[14], o_gk[14], o_pk[7]);
	black bc_8(pkj[8], gkj[12], i_pk[12], i_gk[15], o_gk[15], o_pk[8]);
endmodule

module ks_5 (
	input wire i_c0,
	input wire [8:0] i_pk,
	input wire [15:0] i_gk,
	input wire [15:0] i_p_save,
	output wire o_c0,
	output wire [15:0] o_pk,
	output wire [15:0] o_gk
	);
	wire [8:0] gkj;
	assign o_c0 = i_c0;
	assign o_pk = i_p_save[15:0];
	assign gkj[0] = i_c0;
	assign gkj[8:1] = i_gk[7:0];
	assign o_gk[6:0] = i_gk[7:0];
	grey gc_0(gkj[0], i_pk[0], i_gk[7], o_gk[7]);
	grey gc_1(gkj[1], i_pk[1], i_gk[8], o_gk[8]);
	grey gc_2(gkj[2], i_pk[2], i_gk[9], o_gk[9]);
	grey gc_3(gkj[3], i_pk[3], i_gk[10], o_gk[10]);
	grey gc_4(gkj[4], i_pk[4], i_gk[11], o_gk[11]);
	grey gc_5(gkj[5], i_pk[5], i_gk[12], o_gk[12]);
	grey gc_6(gkj[6], i_pk[6], i_gk[13], o_gk[13]);
	grey gc_7(gkj[7], i_pk[7], i_gk[14], o_gk[14]);
	grey gc_8(gkj[8], i_pk[8], i_gk[15], o_gk[15]);
endmodule

module ks_6 (
	input wire i_c0,
	input wire [15:0] i_pk,
	input wire [15:0] i_gk,
	output wire [15:0] o_s,
	output wire o_carry
	);
	assign o_carry = i_gk[15];
	assign o_s[0] = i_c0 ^ i_pk[0];
	assign o_s[15:1] = i_gk[14:0] ^ i_pk[15:1];
endmodule
