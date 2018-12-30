/* Pipeline Stage 1 */

`ifndef __FETCH_V__
`define __FETCH_V__

module Fetch (
	input wire clk,
	input wire [31:0] pc_in,
	input wire [31:0] instrn_in,
	input wire flush_in,
	input wire hazard_in,
	output reg [31:0] instr_out,
	output reg [31:0] NPC_out
	);

	initial
	begin
		instr_out = 0;
		NPC_out = 0;
	end

	always @ (posedge clk)
	begin
		if (flush_in)
		begin
			instr_out <= 0;
			NPC_out <= 0;
		end
		else
		if (~hazard_in)
		begin
			instr_out <= instrn_in;
			NPC_out <= pc_in;
		end
		else
		begin
			instr_out <= 0;
			NPC_out <= 0;
		end
	end

endmodule

`endif /*__FETCH_V__*/
