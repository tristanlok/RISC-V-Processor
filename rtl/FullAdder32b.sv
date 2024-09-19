/*
Description:
32 bit Full Adder

I/O:
Inputs: operand1(32-bit), operand2(32-bit), carry_in (1-bit)
Outputs: result_out (32-bit), carry_out (1-bit)

Internal Functions:
Ripple carry adder of two 32-bit values using 16-bit full adders
*/

module FullAdder32b(
	input logic [31:0] operand1_in,
	input logic [31:0] operand2_in,
	input logic carry_in,
	output logic [31:0] result_out,
	output logic carry_out
);

logic carry1; // intermediate carry 

FullAdder16b FA0to15 (.operand1_in(operand1_in[15:0]), .operand2_in(operand2_in[15:0]), 
                 .carry_in(carry_in), .result_out(result_out[15:0]), .carry_out(carry1));
FullAdder16b FA16to31 (.operand1_in(operand1_in[31:16]), .operand2_in(operand2_in[31:16]), 
                 .carry_in(carry1), .result_out(result_out[31:16]), .carry_out(carry_out));

endmodule

