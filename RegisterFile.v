`ifndef __REGISTERFILE_V__
`define __REGISTERFILE_V__

module RegisterFile (
	input wire clk,
	input wire write_enable,
	input wire [4:0] Addr_write,
	input wire [4:0] Addr_A,
	input wire [4:0] Addr_B,
	input wire [31:0] Data_in,
	output reg [31:0] DataA,
	output reg [31:0] DataB
	);

	reg [31:0] gpr[0:31];
	reg [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14;
	integer i;

	////////////////////for debug////////////////////////////////////////
	always @ (*)
	begin
		reg0 = gpr[0];
		reg1 = gpr[1];
		reg2 = gpr[2];
		reg3 = gpr[3];
		reg4 = gpr[4];
		reg5 = gpr[5];
		reg6 = gpr[6];
		reg7 = gpr[7];
		reg8 = gpr[8];
		reg9 = gpr[9];
		reg10 = gpr[10];
		reg11 = gpr[11];
		reg12 = gpr[12];
		reg13 = gpr[13];
		reg14 = gpr[14];
	end

	initial // for test
	begin
		gpr[0]  <= 32'h3;	gpr[1]  <= 32'h6;	gpr[3]  <= 32'h2;	gpr[4]  <= 32'h5;
		gpr[5]  <= 32'h7;	gpr[6]  <= 32'h9;	gpr[7]  <= 32'h1;	gpr[8]  <= 32'h4;
		gpr[9]  <= 32'h6;	gpr[10] <= 32'h2;	gpr[11] <= 32'h2;	gpr[12] <= 32'h5;
		gpr[13] <= 32'h7;	gpr[14] <= 32'h9;	gpr[15] <= 32'h1;	gpr[16] <= 32'h4;
		gpr[17] <= 32'h6;	gpr[18] <= 32'h3;	gpr[19] <= 32'h2;	gpr[20] <= 32'h5;
		gpr[21] <= 32'h7;	gpr[22] <= 32'h9;	gpr[23] <= 32'h1;	gpr[24] <= 32'h4;
		gpr[25] <= 32'h6;	gpr[26] <= 32'h3;	gpr[27] <= 32'h2;	gpr[28] <= 32'h5;
		gpr[29] <= 32'h7;	gpr[30] <= 32'h9;	gpr[31] <= 32'h1;	gpr[32] <= 32'h4;
	end

	// write data into register file
	always @ (posedge clk)
	begin
		if (write_enable)
		begin
			gpr[Addr_write] <= Data_in;
		end
	end
	 
	// read data from register file
	always @ (*)
	begin
		DataA <= gpr[Addr_A];
		DataB <= gpr[Addr_B];
	end

endmodule

`endif /*__REGISTERFILE_V__*/
