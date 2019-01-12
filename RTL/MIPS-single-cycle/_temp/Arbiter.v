// Round robin arbiter.

module Arbiter # (
	parameter NUM_ENTRIES = 4
	)	(
	input clk,
	input reset,
	input [NUM_ENTRIES-1:0] request,
	output reg [NUM_ENTRIES-1:0] core_select
	);

	reg [NUM_ENTRIES-1:0] base;
	wire [2*NUM_ENTRIES-1:0] double_request = { request, request };
	wire [2*NUM_ENTRIES-1:0] double_grant = double_request & ~(double_request - base);
	wire [NUM_ENTRIES - 1:0] grant_nxt = double_grant[NUM_ENTRIES * 2 - 1:NUM_ENTRIES] | double_grant[NUM_ENTRIES-1:0];

	always @ (posedge clk, posedge reset)
	begin
		if (reset)
		begin
			base <= 1;
			core_select <= 0;
		end
		else
		begin
			if (grant_nxt != 0)
				base <= { grant_nxt[NUM_ENTRIES - 2:0], grant_nxt[NUM_ENTRIES - 1] }; // Rotate left

			core_select <= grant_nxt;
		end
	end
endmodule
