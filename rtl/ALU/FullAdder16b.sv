/*
Description:
16 bit Full Adder

I/O:
Inputs: operand1(16-bit), operand2(16-bit), carry_in (1-bit)
Outputs: result_out (16-bit), carry_out (1-bit)

Internal Functions:
Ripple carry adder of two 16-bit values using 8-bit full adders
*/

module FullAdder16b(
   input logic [15:0] operand1_in,
   input logic [15:0] operand2_in,
   input logic carry_in,
   output logic [15:0] result_out,
   output logic carry_out
);

logic carry1; // intermediate carry 

FullAdder8b FA0to7 (.operand1_in(operand1_in[7:0]), .operand2_in(operand2_in[7:0]), 
                 .carry_in(carry_in), .result_out(result_out[7:0]), .carry_out(carry1));
FullAdder8b FA8to15 (.operand1_in(operand1_in[15:8]), .operand2_in(operand2_in[15:8]), 
                 .carry_in(carry1), .result_out(result_out[15:8]), .carry_out(carry_out));

endmodule

