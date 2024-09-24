/*
Description:
4 bit Full Adder

I/O:
Inputs: operand1(4-bit), operand2(4-bit), carry_in (1-bit)
Outputs: result_out (4-bit), carry_out (1-bit)

Internal Functions:
Ripple carry adder of two 4-bit values using 1-bit full adders
*/

module FullAdder4b(
	input logic [3:0] operand1_in,
	input logic [3:0] operand2_in,
	input logic carry_in,
	output logic [3:0] result_out,
	output logic carry_out
);

logic carry1, carry2, carry3; // intermediate carry 

FullAdder1b FA0 (.operand1_in(operand1_in[0]), .operand2_in(operand2_in[0]), 
                 .carry_in(carry_in), .result_out(result_out[0]), .carry_out(carry1));
FullAdder1b FA1 (.operand1_in(operand1_in[1]), .operand2_in(operand2_in[1]), 
                 .carry_in(carry1), .result_out(result_out[1]), .carry_out(carry2));
FullAdder1b FA2 (.operand1_in(operand1_in[2]), .operand2_in(operand2_in[2]), 
                 .carry_in(carry2), .result_out(result_out[2]), .carry_out(carry3));
FullAdder1b FA3 (.operand1_in(operand1_in[3]), .operand2_in(operand2_in[3]), 
                 .carry_in(carry3), .result_out(result_out[3]), .carry_out(carry_out));

endmodule

