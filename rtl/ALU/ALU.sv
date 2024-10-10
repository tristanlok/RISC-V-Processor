/*
Description:
Arithmetic Logic Unit (add, subtract, AND, OR, zero flag)

I/O:
Inputs: operand 1 (64-bit), operand 2 (64-bit), ALU opcode (3-bit)
Outputs: result (64-bit), zero flag (1-bit)

Internal Functions:
1. 64-bit ripple carry adder with subtraction and zero flag output
2. 64-bit bitwise OR and AND
3. Multiplexer to choose output (add, subtract, OR, AND) based on opcode
*/

// FOR FORMAL VERIFICATION ONLY -> UNCOMMENT FOR PRODUCTION
typedef enum logic [2:0] {
   OP_ADD = 3'b111,  // ALU operation: Add
   OP_SUB = 3'b000,  // ALU operation: Subtract
   OP_AND = 3'b001,  // ALU operation: AND
   OP_OR  = 3'b011   // ALU operation: OR
} Alu_Operation_t;

//module ALU import control_signals::Alu_Operation_t(
module ALU (
   input    logic [63:0]      operand1_in,
   input    logic [63:0]      operand2_in,
   input    Alu_Operation_t   aluOpcode_in,
   
   output   logic [63:0]      result_out,
   output   logic             zeroFlag_out
);

logic          subEnable;
logic [63:0]   operand2Modified; // inverted version of operand2_in if subtraction is enabled for 2's complement
logic [63:0]   orResult;
logic [63:0]   andResult;
logic [63:0]   adderResult;

// subEnable and create operand2Modified
always_comb begin

   subEnable = ~&aluOpcode_in;
   
   operand2Modified = operand2_in ^ {64{subEnable}}; // {64{subEnable}} replicates subEnable 64 times to become

end

// Full Adder/Subtractor (terminate carry_out)
/* verilator lint_off PINCONNECTEMPTY */
FullAdder64b FA (.operand1_in(operand1_in), .operand2_in(operand2Modified), 
                 .carry_in(subEnable), .result_out(adderResult), .carry_out());

// bitwise OR
always_comb begin

   orResult = operand1_in | operand2_in;

end

// bitwise AND
always_comb begin

   andResult = operand1_in & operand2_in;

end

// Multiplexer to choose result
always_comb begin
   case(aluOpcode_in)

      OP_SUB:  result_out = adderResult; //SUB
      OP_AND:  result_out = andResult; //AND
      OP_OR:   result_out = orResult; //OR
      OP_ADD:  result_out = adderResult; //ADD
      
      //default case right now (full adder)
      default: result_out = adderResult;
      
   endcase
end

// zero flag
always_comb begin

   zeroFlag_out = ~|result_out;

end

endmodule

