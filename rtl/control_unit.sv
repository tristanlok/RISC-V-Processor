module control_unit (
	input [31:0]	instruction,
	
	output			reg_alu_mux,
	output			mem_read,
	output			mem_write,
	output [1:0]	alu_op,
	output			reg_write,
	output			data_reg_mux,
	output			branch_ctrl
);

enum logic [3:0] {
	OP_ADD = 2'b00,
	OP_SUB = 2'b01,
	OP_AND = 2'b10,
	OP_OR	 = 2'b11
} Alu_OP;

always_comb begin
	case (

endmodule
