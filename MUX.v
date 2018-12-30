`ifndef __MUX_V__
`define __MUX_V__

module MUX (
	input wire [31:0] A0,
	input wire [31:0] A1,
	input wire [31:0] A2,
	input wire [31:0] A3,
	input wire [1:0] Sel,
	output reg [31:0] Out
	);

	initial
	begin
		Out = 32'b0;
	end

	always @ (*)
	begin
		case (Sel)
            2'b00: Out <= A0;
            2'b01: Out <= A1;
            2'b10: Out <= A2;
            2'b11: Out <= A3;
		endcase
	end

endmodule

`endif /*__MUX_V__*/
