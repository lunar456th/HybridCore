`default_nettype none
	
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
