`default_nettype none

module adder_tb ();
	reg [15:0] a;
	reg [15:0] b;
	reg c_in;
	wire [15:0] s;
	wire c_out;
	reg [16:0] check;
	
	integer i, j, k;
	integer num_correct;
	integer num_wrong;
	
	adder adder(a, b, c_in, s, c_out);
	
	initial
	begin
		$display("Running testbench, this may take a minute or two...");
		num_correct = 0;
		num_wrong = 0;

		for (i = 0; i < 65536; i = i + 1)
		begin
			a = i;
			for (j = 0; j < 65536; j = j + 1)
			begin
				b = j;
				for (k = 0; k < 2; k = k + 1)
				begin
					c_in = k;
					check = a + b + c_in;
					#2;
					if ({c_out, s} == check)
						num_correct = num_correct + 1;
					else
						num_wrong = num_wrong + 1;
				end
			end
		end
		
		$display("num_correct = %d, num_wrong = %d", num_correct, num_wrong);
		$finish;
	end
	
endmodule
