/* Pipeline Stage 5 */

`ifndef __WRITEBACK_V__
`define __WRITEBACK_V__

module Writeback (
	//input wire clk,
	input wire [1:0] WB_in,
	input wire [4:0] RD_in,
	input wire [31:0] MEM_in,
	input wire [31:0] ALU_in,
	output reg [1:0] WB_out,
	output reg [4:0] RD_out,
	output reg [31:0] MEM_out,
	output reg [31:0] ALU_out
	);

	initial
	begin
		WB_out = 0;
		RD_out = 0;
		MEM_out = 0;
		ALU_out = 0;
	end

	//always @ (posedge clk)
	always @ (*)
	begin
		WB_out <= WB_in;
		RD_out <= RD_in;
		MEM_out <= MEM_in;
		ALU_out <= ALU_in;
	end

endmodule

`endif /*__WRITEBACK_V__*/
