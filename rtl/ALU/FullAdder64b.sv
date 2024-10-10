/*
Description:
64 bit Full Adder

I/O:
Inputs: operand1(64-bit), operand2(64-bit), carry_in (1-bit)
Outputs: result_out (64-bit), carry_out (1-bit)

Internal Functions:
Ripple carry adder of two 64-bit values using 32-bit full adders
*/

module FullAdder64b(
   input logic [63:0] operand1_in,
   input logic [63:0] operand2_in,
   input logic carry_in,
   output logic [63:0] result_out,
   output logic carry_out
);

logic carry1; // intermediate carry 

FullAdder32b FA0to31 (.operand1_in(operand1_in[31:0]), .operand2_in(operand2_in[31:0]), 
                 .carry_in(carry_in), .result_out(result_out[31:0]), .carry_out(carry1));
FullAdder32b FA32to64 (.operand1_in(operand1_in[63:32]), .operand2_in(operand2_in[63:32]), 
                 .carry_in(carry1), .result_out(result_out[63:32]), .carry_out(carry_out));

endmodule

