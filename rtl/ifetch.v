/*
	Name		:	Instruction Fetch Unit
	File		:	ifetch.v
	Word size	:	16-bit
*/

module instr_fetch (
	input wire clk,
	input wire reset,
	
	input wire ex_if_branch_en,
	input wire [15:0] ex_if_branch_target,
	
	output reg [15:0] if_id_pc,
	output reg [15:0] if_id_instr,

	output reg mem_r_en,
	output reg [15:0] mem_r_addr,
	input wire [15:0] mem_r_data,
	
	input wire stall
	);
	
	reg [15:0] pc;
	reg [15:0] pc_nxt;
	
	always @ (*)
	begin
		if (ex_if_branch_en)
			pc_nxt = ex_if_branch_target;
		else if (stall)
			pc_nxt = pc;
		else 
			pc_nxt = pc + 16'd1;

	end
	
	always @ (pc_nxt)
	begin
        mem_r_addr = pc_nxt;
        mem_r_en = 1'b1;
        if_id_instr = mem_r_data;
	end
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			if_id_pc <= 0;
			pc <= 16'hffff;
		end
		else if (!stall)
		begin
			pc <= pc_nxt;
			if_id_pc <= mem_r_addr + 16'd1;
		end
	end
	
endmodule
