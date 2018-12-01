`timescale 1ns / 1ps

module tb_Booth_Multiplier_4xA();

	parameter N = 8;

	reg Rst;
	reg Clk;

	reg Ld;
	reg [(N - 1):0] M;
	reg [(N - 1):0] R;

	wire Valid, Valid_A;
	wire [((2*N) - 1):0] P, P_A;

	// Simulation Variables

	reg [(2*N):0] i;

	// Instantiate the Unit Under Test (UUT)

	Booth_Multiplier_4x #(.N(N)) uut (
		.Rst(Rst), 
		.Clk(Clk), 
		.Ld(Ld), 
		.M(M), 
		.R(R), 
		.Valid(Valid), 
		.P(P)
	);

	Booth_Multiplier_4xA #(.N(N)) RevA (
		.Rst(Rst), 
		.Clk(Clk), 
		.Ld(Ld), 
		.M(M), 
		.R(R), 
		.Valid(Valid_A), 
		.P(P_A)
	);

	initial
	begin
		// Initialize Inputs
		Rst = 1;
		Clk = 1;
		Ld = 0;
		M = 0;
		R = 0;
		
		i = 0;

		// Wait 100 ns for global reset to finish
		#101 Rst = 0;
		
		// Add stimulus here
		
		@(posedge Clk) #1;
		
		for(i = (2**N); i < (2**(2*N)) + 1; i = i + 1)
		begin
			Ld = 1; M = i[((2*N) - 1):N]; R = i[(N - 1):0];
			@(posedge Clk) #1 Ld = 0;
			@(posedge Valid);
			if(Valid_A != 1)
			begin
				$display(" Fail - Module did not assert Valid as Expected\n");
				$stop;
			end
			if(P != P_A)
			begin
				$display(" Fail - Module product does not match expected value\n");
				$stop;
			end
		end
		
		// Exit - End of Test
		
		@(posedge Clk) #1;
		@(posedge Clk) #1;
		@(posedge Clk) #1;
		@(posedge Clk) #1;

		$display(" Pass\n");
		$stop;
	end

	always #5 Clk = ~Clk;

endmodule