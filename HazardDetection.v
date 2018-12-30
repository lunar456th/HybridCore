`ifndef __HAZARDDETECTION_V__
`define __HAZARDDETECTION_V__

module HazardDetection (
    input wire decode_MEM1,
	input wire [4:0] decode_RT,
    input wire [4:0] RS_in_decoder,
	input wire [4:0] RT_in_decoder,
    output reg PC_hz,
	output reg decoderin_hz,
	output reg hazard_hz
	);

	always @ (*)
	begin
		if ((decode_MEM1) && ((decode_RT == RS_in_decoder) | (decode_RT == RT_in_decoder)))   
		begin
			PC_hz = 0;
			decoderin_hz = 0;
			hazard_hz = 1;
		end
		else
		begin
			PC_hz = 1;
			decoderin_hz = 1;
			hazard_hz = 0;
		end
	end

endmodule

`endif /*__HAZARDDETECTION_V__*/
