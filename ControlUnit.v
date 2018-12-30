`ifndef __CONTROLUNIT_V__
`define __CONTROLUNIT_V__

module ControlUnit (
	input wire [5:0] Opcode,
	output wire [8:0] Op_out,
	output wire jmp,
	output wire bne,
	output wire immediate,
	output wire andi,
	output wire ori,
	output wire addi,
	output wire ls //,push_andi,push_ori,push_addi;
	);

	wire r, lw, sw, me;

	wire [3:0] tmp1;
	wire [1:0] tmp2;

	////////////////////////////appropriate bit is made 1 according to the opcode received/////////////////
	assign r = ~Opcode[5] & ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & ~Opcode[1] & ~Opcode[0];
	assign lw = Opcode[5] & ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & Opcode[1] & Opcode[0];
	assign sw = Opcode[5] & ~Opcode[4] & Opcode[3] & ~Opcode[2] & Opcode[1] & Opcode[0];
	assign beq = ~Opcode[5] & ~Opcode[4] & ~Opcode[3] & Opcode[2] & ~Opcode[1] & ~Opcode[0];
	assign bne = ~Opcode[5] & ~Opcode[4] & ~Opcode[3] & Opcode[2] & ~Opcode[1] & Opcode[0];
	assign jmp = ~Opcode[5] & ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & Opcode[1] & ~Opcode[0];
	assign andi = ~Opcode[5] & ~Opcode[4] & Opcode[3] & Opcode[2] & ~Opcode[1] & ~Opcode[0];
	assign ori = ~Opcode[5] & ~Opcode[4] & Opcode[3] & Opcode[2] & ~Opcode[1] & Opcode[0];
	assign addi = ~Opcode[5] & ~Opcode[4] & Opcode[3] & ~Opcode[2] & ~Opcode[1] & ~Opcode[0];
	assign immediate = andi | ori | addi;

	//Load store
	assign ls = lw| sw;

	// EXE bits
	assign tmp1[3] = r;
	assign tmp1[2] = lw | sw | immediate;
	assign tmp1[1] = r;
	assign tmp1[0] = beq;

	//WB bits
	assign tmp2[1] = lw;
	assign tmp2[0] = r | lw | immediate;

	//Op
	assign Op_out[8:7] = tmp2; //WB
	assign Op_out[6:4] = { beq, lw, sw }; //MEM  
	assign Op_out[3:0] = tmp1; //EXE

endmodule

`endif /*__CONTROLUNIT_V__*/
