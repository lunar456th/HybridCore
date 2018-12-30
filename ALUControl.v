`ifndef __ALU_CONTROL_V__
`define __ALU_CONTROL_V__

module ALUControl (
	input wire [5:0] operation,
	input wire [1:0] ALU_Op,
	input wire andi,
	input wire ori,
	input wire addi,
	input wire push_ls,
	output reg [2:0] ALU_control
	);

	///////////////////////////Compute ALU control from the output given from the control unit//////////
	initial
	begin
		ALU_control = 0;
	end

	always @ (ALU_Op or operation or andi or ori or addi or push_ls)
	begin
		case (ALU_Op)
			2'b10: //R Type
			begin
				if (operation == 6'b100100)
				begin
					ALU_control <= 3'b000; //and
				end
				if (operation == 6'b100101)
				begin
					ALU_control <= 3'b001; //or
				end
				if (operation == 6'b100000)
				begin
					ALU_control <= 3'b010; //add
				end
				if (operation == 6'b011000)
				begin
					ALU_control <= 3'b011; //multi
				end
				if (operation == 6'b100011)
				begin
					ALU_control <= 3'b110; //sub
				end
			end

			2'b00: //I type
			begin
				if (andi)
				begin
					ALU_control <= 3'b000; //andi
				end
				if (ori)
				begin
					ALU_control <= 3'b001; //ori
				end
				if (addi)
				begin
					ALU_control <= 3'b010; //addi
				end
				if (push_ls)
				begin
					ALU_control <= 3'b010; //addi
				end
			end
		endcase
	end

endmodule

`endif /*__ALU_CONTROL_V__*/
