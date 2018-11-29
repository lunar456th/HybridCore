`define WIDTH 64

module carry_lookahead_adder
	#(parameter WIDTH)
	(
		input wire	[WIDTH-1:0]	i_add1,
		input wire	[WIDTH-1:0]	i_add2,
		output wire	[WIDTH:0]	o_result
	);

	wire [WIDTH:0]     w_C;
	wire [WIDTH-1:0]   w_G, w_P, w_SUM;

	genvar i, j;

	// Create the Full Adders
	generate
		for (i=0; i<WIDTH; i=i+1) 
		begin
			full_adder full_adder_inst
			( 
				.i_bit1(i_add1[i]),
				.i_bit2(i_add2[i]),
				.i_carry(w_C[i]),
				.o_sum(w_SUM[i]),
				.o_carry()
			);
		end
	endgenerate

	// Create the Generate  (G) Terms: Gi = Ai * Bi
	// Create the Propagate (P) Terms: Pi = Ai + Bi
	// Create the Carry Terms:
	generate
		for (j=0; j<WIDTH; j=j+1) 
		begin
			assign w_G[j]   = i_add1[j] & i_add2[j];
			assign w_P[j]   = i_add1[j] | i_add2[j];
			assign w_C[j+1] = w_G[j]	| (w_P[j] & w_C[j]);
		end
	endgenerate

	assign w_C[0] = 1'b0; // no carry input on first adder

	assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation

endmodule // carry_lookahead_adder