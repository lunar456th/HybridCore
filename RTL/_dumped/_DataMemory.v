`ifndef __DATAMEMORY_V__
`define __DATAMEMORY_V__

module DataMemory (
	input wire [31:0] Address,
	input wire [31:0] Write_data,
	input wire Mem_Write,
	input wire Mem_Read,
	output reg [31:0] Read_data
	);

	reg [31:0] data_mem[0:63];
	reg [31:0] data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data17, data21, data48;
	integer i;

	initial // for test
	begin
		Read_data <= 32'b0;
		data_mem[21] <= 32'd3;
	end

	///////////////////for debug///////////////////////////////
	always @ (*)
	begin
		data0 <= data_mem[0];
		data1 <= data_mem[1];
		data2 <= data_mem[2];
		data3 <= data_mem[3];
		data4 <= data_mem[4];
		data5 <= data_mem[5];
		data6 <= data_mem[6];
		data7 <= data_mem[7];
		data8 <= data_mem[8];
		data9 <= data_mem[9];
		data17 <= data_mem[17];
		data21 <= data_mem[21];
		data48 <= data_mem[48];
	end

	// Write
	always @ (*)
	begin
		if (Mem_Write)
		begin
			data_mem[Address] <= Write_data;
		end
	end

	// Read
	always @ (*)
	begin
		if (Mem_Read)
		begin
			Read_data <= data_mem[Address];
		end
	end

endmodule

`endif /*__DATAMEMORY_V__*/
