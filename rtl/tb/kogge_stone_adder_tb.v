module KSA64_tb();
	reg [63:0] a, b;
	reg cin;
	wire [63:0] sum;
	wire cout;
	
	KSA64 ksa64(a[63:0], b[63:0], sum[63:0], cout);
	
	initial
	begin
		$display("a|b||cout|sum");
	end
	
	initial
	begin
		$monitor("%d|%d||%d|%h", a[63:0], b[63:0], cout, sum[63:0]);
	end
	
	initial
	begin
		a = 64'd998; b = 64'd128;
		#10 a = 64'd9998; b = 64'd9028;
		#10 a = 64'hfaaaaaaafaaaaaaa; b = 64'hfaaaaaaadbbbbbbb;
	end
	
endmodule
