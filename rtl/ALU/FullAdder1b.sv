/*
Description:
1 bit Full Adder for the larger 64-bit Full Adder

I/O:
Inputs: operand1(1-bit), operand2(1-bit), carry_in (1-bit)
Outputs: result_out (1-bit), carry_out (1-bit)

Internal Functions:
Arithmetic full adding of two 1-bit values with carry in and carry out
*/

module FullAdder1b(
	input logic operand1_in,
	input logic operand2_in,
	input logic carry_in,
	output logic result_out,
	output logic carry_out
);

always_comb begin

	result_out = (operand1_in ^ operand2_in) ^ carry_in;

	carry_out = (operand1_in & operand2_in) | ((operand1_in ^ operand2_in) & carry_in);
	
end

endmodule
