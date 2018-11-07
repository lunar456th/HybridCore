// 뭔가 꺼림칙하니 다른 Decode Unit 찾아보기

/*
	Name		:	Decode Unit
	Word size	:	16-bit
	Detail of Instruction	:	[15:11]	- OpCode
								[10]	- Adressing Mode(Direct Mode or Immediate Mode)
								[9:5]	- Operand A(Register Index)
								[4:0]	- Operand B(Register Index or Immediate)
*/

module decode (
	input wire clk,
	input wire [15:0] instr,
	output reg [4:0] opcode,
	output reg addr_mode,
	output reg [4:0] reg_idx_a,
	output reg [4:0] reg_idx_b,
	output reg [3:0] cond
	);
	
	always @ (posedge clk)
	begin
		opcode <= instr[15:11];
		addr_mode <= instr[10];
		reg_idx_a <= instr[9:5];
		reg_idx_b <= instr[4:0];
		cond <= instr[3:0];
	end
	
endmodule
