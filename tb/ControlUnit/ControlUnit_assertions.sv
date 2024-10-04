module ControlUnit_assertions import temp::*; (
	input logic [6:0] opcode_in,
	input logic [2:0] funct3_in,
	input logic [6:0] funct7_in,
   output reg_alu_ctrl_t      reg_alu_mux,
   output logic               mem_read,
   output logic               mem_write,
   output Alu_Operation_t     alu_op,
   output logic               reg_write,
   output data_reg_ctrl_t     data_reg_mux,
   output logic               branch_ctrl
);