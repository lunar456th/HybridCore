`default_nettype none

module multiplier_tb();
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] s;
	reg [31:0] check;
    
    integer i, j;
	integer num_correct;
	integer num_wrong;
    
    multiplier multiplier(a, b, s);
    
    initial
    begin
		$display("Running testbench, this may take a minute or two...");
        correct = 0;
        incorrect = 0;
		
        for (i = 0; i < 65536; i = i + 1)
        begin
			a = i;
            for (j = 0; j < 65536; j = j + 1)
            begin
                b = j;
				check = a * b;
                #2;
				if (s == check)
					num_correct = num_correct + 1;
				else
					num_wrong = num_wrong + 1;
            end
        end
		
		$display("num_correct = %d, num_wrong = %d", num_correct, num_wrong);
		$finish;
	end
	
endmodule