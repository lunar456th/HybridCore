`ifndef __CORE_V__
`define __CORE_V__

`include "ALU.v"
`include "ALUControl.v"

`include "RegisterFile.v"
`include "InstructionMemory.v"
`include "DataMemory.v"

`include "Fetch.v"
`include "Decode.v"
`include "Execute.v"
`include "Writeback.v"
`include "ControlUnit.v"

`include "HazardDetection.v"
`include "ForwardingUnit.v"

`include "MUX.v"

module Core (
	input clk,
	input reset,
	input core_enable,
	output core_request,

	output [31:0] memory_addr,
	output memory_rden,
	output memory_wren,
	input [31:0] memory_read_val,
	output [31:0] memory_write_val,
	input memory_response
	);
	
	// Fetch Wire Declarations
	wire [31:0] PC_In;
	wire [31:0] PC_Next;
	wire [31:0] PC_Out;
	wire hazard_hz;
	wire PC_hz;
	wire decoderin_hz;
	wire [31:0] instr_out, NPC_out;
	reg[31:0] PC;

	// Decode, Execute, Memory Wire Declarations
	wire [1:0] decode_WB;
	wire [1:0] exe_WBout;
	wire [1:0] mem_WBout;
	wire [2:0] decode_MEM;
	wire [2:0] exe_MEMout;
	wire [3:0] decode_EXE;
	wire [4:0] RS_in_decoder;
	wire [4:0] RT_in_decoder;
	wire [4:0] RD_in_decoder;
	wire [4:0] mem_RDout;
	wire [4:0] exe_RD_in;
	wire [4:0] exe_RDout;
	wire [31:0] imm_in_decoder;
	wire [31:0] Instrn;
	wire [31:0] muxB_in;

	wire [4:0] decode_RS;
	wire [4:0] decode_RT;
	wire [4:0] decode_RD; //exe_RD_in, exe_RDout;
	wire [31:0] decode_dataA;
	wire [31:0] decode_dataB;
	wire [31:0] decode_imm;
	wire [31:0] regmem_DataA;
	wire [31:0] regmem_DataB;

	wire [8:0] decoder_in;
	wire [8:0] ControlUnit_Out;

	wire [4:0] EXERt_in;
	wire EXEMem_in;

	wire [1:0] FwdOut_A, FwdOut_B;

	// Control Wire Declarations
	wire [5:0] Opcode;
	wire jmp, bne, imm, andi, ori, addi, ls;

	wire [31:0] ReadOut_DataMem;
	wire [31:0] write_data;
	wire [31:0] mem_DataOut;
	wire [31:0] ALUout_A;
	wire [31:0] ALUout_B;
	wire [31:0] ALU_out;
	wire [31:0] exe_ALUout;
	wire [31:0] mem_ALUout;
	wire [31:0] exe_WriteData;
	wire [2:0] ALU_Control;
	wire push_andi, push_ori, push_addi;

	reg push_andi_tmp, push_ori_tmp, push_addi_tmp, push_ls;

	//---//


	// Assignments
	assign PC_In = PC + 1;
	assign PC_Next = PC_In;

	assign RS_in_decoder = instr_out[25:21];
	assign RT_in_decoder = instr_out[20:16];
	assign RD_in_decoder = instr_out[15:11];
	assign imm_in_decoder = { { 16{ instr_out[15] } }, instr_out[15:0] };


	assign decoder_in = (decoderin_hz ? ControlUnit_Out : 0);

	assign Opcode=instr_out[31:26];

	assign exe_RD_in = (decode_EXE[3] ? decode_RD : decode_RT);
	assign muxB_in = (decode_EXE[2] ? decode_imm : decode_dataB);

	assign write_data = (mem_WBout[1] ? mem_DataOut : mem_ALUout);

	assign push_andi = push_andi_tmp;
	assign push_addi = push_addi_tmp;
	assign push_ori = push_ori_tmp;

	initial
	begin
		PC = 0;
		//count = 0;
	end

	always @ (posedge clk)
	begin
		//count = count + 1;
		if (PC_hz)
		begin
			PC = PC_Next;
		end
	end

	// push flags
	always @ (posedge clk)
	begin
		push_andi_tmp <= andi;
		push_addi_tmp <= addi;
		push_ori_tmp <= ori;
		push_ls <= ls;
	end

	//---//

	// Instantiations
	InstructionMemory Stage1(
		.PC(PC),
		.instruction(Instrn),
		.memory_addr(memory_addr),
		.memory_rden(memory_rden),
		.memory_read_val(memory_read_val),
		.memory_response(memory_response)
	);

	Fetch Stage2(
		.clk(clk),
		.pc_in(PC_In),
		.instrn_in(Instrn),
		.flush_in(reset),
		.hazard_in(hazard_hz),
		.instr_out(instr_out),
		.NPC_out(NPC_out)
	);

	HazardDetection Stage3(
		.decode_MEM1(decode_MEM[1]),
		.decode_RT(decode_RT),
		.RS_in_decoder(RS_in_decoder),
		.RT_in_decoder(RT_in_decoder),
		.PC_hz(PC_hz),
		.decoderin_hz(decoderin_hz),
		.hazard_hz(hazard_hz)
	);

	ControlUnit Stage4(
		.Opcode(Opcode),
		.Op_out(ControlUnit_Out),
		.jmp(jmp),
		.bne(bne),
		.immediate(imm),
		.andi(andi),
		.ori(ori),
		.addi(addi),
		.ls(ls)
	);

	RegisterFile Stage5(
		//.clk(clk),
		.write_enable(mem_WBout[0]),
		.Addr_write(mem_RDout),
		.Addr_A(instr_out[25:21]),
		.Addr_B(instr_out[20:16]),
		.Data_in(write_data),
		.DataA(regmem_DataA),
		.DataB(regmem_DataB)
	);

	Decode Stage6(
		//.clk(clk),
		.decoder_in(decoder_in),
		.dataA_in(regmem_DataA),
		.dataB_in(regmem_DataB),
		.instr_in(instr_out),
		.ls(ls),
		.WB_out(decode_WB),
		.MEM_out(decode_MEM),
		.EXE_out(decode_EXE),
		.RS_out(decode_RS),
		.RT_out(decode_RT),
		.RD_out(decode_RD),
		.dataA_out(decode_dataA),
		.dataB_out(decode_dataB),
		.imm_out(decode_imm)
	);

	MUX _MuxA(
		.A0(decode_dataA),
		.A1(write_data),
		.A2(exe_ALUout),
		.A3(0),
		.Sel(FwdOut_A),
		.Out(ALUout_A)
	);

	MUX _MuxB(
		.A0(muxB_in),
		.A1(write_data),
		.A2(exe_ALUout),
		.A3(0),
		.Sel(FwdOut_B),
		.Out(ALUout_B)
	);

	ForwardingUnit Stage7(
		.exe_RDout(exe_RDout),
		.mem_RDout(mem_RDout),
		.decode_RS(decode_RS),
		.decode_RT(decode_RT),
		.exe_WBout0(exe_WBout[0]),
		.mem_WBout0(mem_WBout[0]),
		.ls(push_ls),
		.ForwardA(FwdOut_A),
		.ForwardB(FwdOut_B)
	);

	ALUControl Stage8(
		.operation(decode_imm[5:0]),
		.ALU_Op(decode_EXE[1:0]),
		.andi(push_andi),
		.ori(push_ori),
		.addi(push_addi),
		.push_ls(push_ls),
		.ALU_control(ALU_Control)
	);

	ALU Stage9(
		.DataA(ALUout_A),
		.DataB(ALUout_B),
		.ALU_control(ALU_Control),
		.hazard_hz(hazard_hz),
		.Result(ALU_out)
	);

	Execute Stage10(
		//.clk(clk),
		.WB_in(decode_WB),
		.MEM_in(decode_MEM),
		.RD_in(exe_RD_in),
		.ALU_in(ALU_out),
		.WriteData_in(decode_dataB),
		.WB_out(exe_WBout),
		.MEM_out(exe_MEMout),
		.RD_out(exe_RDout),
		.ALU_out(exe_ALUout),
		.WriteData_out(exe_WriteData)
	);

	DataMemory Stage11(
		.Address(exe_ALUout),
		.Write_data(exe_WriteData),
		.Mem_Write(exe_MEMout[0]),
		.Mem_Read(exe_MEMout[1]),
		.Read_data(ReadOut_DataMem)
		.memory_addr(memory_addr),
		.memory_rden(memory_rden),
		.memory_wren(memory_wren),
		.memory_read_val(memory_read_val),
		.memory_write_val(memory_write_val),
		.memory_response(memory_response)
	);

	Writeback Stage12(
		//.clk(clk),
		.WB_in(exe_WBout),
		.RD_in(exe_RDout),
		.MEM_in(ReadOut_DataMem),
		.ALU_in(exe_ALUout),
		.WB_out(mem_WBout),
		.RD_out(mem_RDout),
		.MEM_out(mem_DataOut),
		.ALU_out(mem_ALUout)
	);

endmodule

`endif /*__CORE_V__*/
