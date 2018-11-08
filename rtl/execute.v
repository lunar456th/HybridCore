/*
	Name		:	Execution Unit
	File		:	execute.v
	Word size	:	16-bit
*/

module execute (
	input wire clk,
	input wire reset,

	input wire [4:0] of_ex_op,
	input wire [15:0] of_ex_operand_a,
	input wire [15:0] of_ex_operand_b,
	input wire [4:0] of_ex_reg_idx_dst,
	
	output reg reg_r_en,
	output reg [15:0] reg_r_idx,
	input wire [15:0] reg_r_data,

	output reg mem_r_en,
	output reg [15:0] mem_r_addr,
	input wire [15:0] mem_r_data,
	output reg mem_w_en,
	output reg [15:0] mem_w_addr,
	output reg [15:0] mem_w_data,
	
	output reg [15:0] ex_wb_result,
	output reg [3:0] ex_wb_nzcv,
	output wire [4:0] ex_wb_reg_idx_dst,
	
	output wire ex_if_branch_en, /////////////
	output wire [15:0] ex_if_branch_target, //////////////
	
	);
	
	wire [15:0] sr;
	
	assign ex_wb_reg_idx_dst = of_ex_reg_idx_dst;
	
	always @ (posedge clk or negedge reset)
	begin
		if (~reset)
		begin
			ex_wb_result = 0;
			ex_wb_nzcv = 0;
			ex_wb_reg_idx_dst = 0;
		end
		else
		begin
			casex (of_ex_op) // ...
				5'b0xxxx: // alu operation
					alu alu(
						.op(of_ex_op),
						.a(of_ex_operand_a),
						.b(of_ex_operand_b),
						.result(ex_wb_result),
						.nzcv()
					);
						
				5'b10000: // mov operation
					ex_alu_result = of_ex_operand_b;
				5'b10010: // load operation
				5'b10011: // store operation
					ex_alu_result = of_ex_operand_b;
				5'b10100: // MSR
				5'b10101: // MRS
				5'b10110: // PUSH
				5'b10111: // POP
				5'b11000: // branch operation
				5'b11010: // CALL
				5'b11011: // RET
				5'b11100: // INT
				5'b11111: // NOP
			endcase
		end
	end
	
endmodule
