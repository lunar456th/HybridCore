`ifndef __ALU_V__
`define __ALU_V__

module ALU (
	input wire [31:0] DataA,
	input wire [31:0] DataB,
	input wire [2:0] ALU_control,
	input wire hazard_hz,
	output reg [31:0] Result
	);

	// perform operation according to the control from ALU control unit
	always @ (ALU_control or DataA or DataB)
	begin
		case (ALU_control)
			3'b000: Result = (DataA & DataB); // logical and
			3'b001: Result = (DataA | DataB); // logical or
			3'b010: Result = (DataA + DataB); // addition
			3'b011: Result = (DataA * DataB); // multiply
			3'b110: Result = (DataA - DataB); // subtract
			default: Result = 32'b0; // Default
		endcase
	end

endmodule

`endif /*__ALU_V__*/
