/* Pipeline Stage 3 */

`ifndef __EXECUTE_V__
`define __EXECUTE_V__

module Execute (
	// input wire clk,
	input wire [1:0] WB_in,
	input wire [2:0] MEM_in,
	input wire [4:0] RD_in,
	input wire [31:0] ALU_in,
	input wire [31:0] WriteData_in,
	output reg [1:0] WB_out,
	output reg [2:0] MEM_out,
	output reg [4:0] RD_out,
	output reg [31:0] ALU_out,
	output reg [31:0] WriteData_out
	);

	initial
	begin
		WB_out = 0;
		MEM_out = 0;
		RD_out = 0;
		ALU_out = 0;
	end

	// always @ (posedge clk)
	always @ (*)
	begin
		WB_out <= WB_in;
		MEM_out <= MEM_in;
		RD_out <= RD_in;
		ALU_out <= ALU_in;
		WriteData_out <= WriteData_in;
	end

endmodule

`endif /*__EXECUTE_V__*/
