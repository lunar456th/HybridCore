/* Pipeline Stage 2 */

`ifndef __DECODE_V__
`define __DECODE_V__

module Decode (
	// input wire clk,
	input wire [8:0] decoder_in,
	input wire [31:0] dataA_in,
	input wire [31:0] dataB_in,
	input wire [31:0] instr_in,
	input wire ls,
	output reg [1:0] WB_out,
	output reg [2:0] MEM_out,
	output reg [3:0] EXE_out,
	output reg [4:0] RS_out,
	output reg [4:0] RT_out,
	output reg [4:0] RD_out,
	output reg [31:0] dataA_out,
	output reg [31:0] dataB_out,
	output reg [31:0] imm_out
	);

	initial
	begin
		WB_out = 0;
		MEM_out = 0;
		EXE_out = 0;
		RS_out = 0;
		RT_out = 0;
		RD_out = 0;
		dataA_out = 0;
		dataB_out = 0;
		imm_out = 0;
	end

	// always @ (posedge clk)
	always @ (*)
	begin
		WB_out <= decoder_in[8:7];
		MEM_out <= decoder_in[6:4];
		EXE_out <= decoder_in[3:0];
		RS_out <= instr_in[25:21];
		RT_out <= instr_in[20:16];
		RD_out <= instr_in[15:11];
		dataA_out <= (ls ? instr_in[25:21] : dataA_in);
		dataB_out <= dataB_in;
		imm_out <= { { 16{ instr_in[15] } }, instr_in[15:0] };
	end

endmodule

`endif /*__DECODE_V__*/