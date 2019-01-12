`ifndef __FORWARDINGUNIT_V__
`define __FORWARDINGUNIT_V__

module ForwardingUnit (
	input wire [4:0] exe_RDout,
	input wire [4:0] mem_RDout,
	input wire [4:0] decode_RS,
	input wire [4:0] decode_RT,
	input wire exe_WBout0,
	input wire mem_WBout0,
	input wire ls,
	output reg [1:0] ForwardA,
	output reg [1:0] ForwardB
	);

	// checking hazards
	always @ (*)
	begin
		if ((exe_WBout0) && (exe_RDout != 0) && (exe_RDout == decode_RS))
		begin
			ForwardA = 2'b10;
		end
		else if ((mem_WBout0) && (mem_RDout != 0) && (mem_RDout == decode_RS) && (exe_RDout != decode_RS))
		begin
			ForwardA = 2'b01;
		end
		else
		begin
			ForwardA = 2'b00;
		end
	end

	/////////////////////////////////////////check for hazards////////////////////////////////////
	always @ (*)
	begin
		if ((mem_WBout0) && (mem_RDout != 0) && (mem_RDout == decode_RT) && (exe_RDout != decode_RT) && (!ls))
		begin
			ForwardB = 2'b01;
		end
		else if((exe_WBout0) && (exe_RDout != 0) && (exe_RDout == decode_RT) && (!ls))
		begin
			ForwardB = 2'b10;
		end
		else
		begin
			ForwardB = 2'b00;
		end
	end

endmodule

`endif /*__FORWARDINGUNIT_V__*/
