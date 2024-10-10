/*
Description:
8 bit Full Adder

I/O:
Inputs: operand1(8-bit), operand2(8-bit), carry_in (1-bit)
Outputs: result_out (8-bit), carry_out (1-bit)

Internal Functions:
Ripple carry adder of two 8-bit values using 4-bit full adders
*/

module FullAdder8b(
   input logic [7:0] operand1_in,
   input logic [7:0] operand2_in,
   input logic carry_in,
   output logic [7:0] result_out,
   output logic carry_out
);

logic carry1; // intermediate carry 

FullAdder4b FA0to3 (.operand1_in(operand1_in[3:0]), .operand2_in(operand2_in[3:0]), 
                 .carry_in(carry_in), .result_out(result_out[3:0]), .carry_out(carry1));
FullAdder4b FA4to7 (.operand1_in(operand1_in[7:4]), .operand2_in(operand2_in[7:4]), 
                 .carry_in(carry1), .result_out(result_out[7:4]), .carry_out(carry_out));

endmodule

