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

// FOR FORMAL VERIFICATION ONLY | SYMBIYOSYS DOES NOT SUPPORT PACKAGES
/*
typedef enum logic [2:0] {
   OP_ADD = 3'b111,
   OP_SUB = 3'b000,
   OP_AND = 3'b001,
   OP_OR  = 3'b011
} aluOperation_t;

module ALU (
*/

module ALU import ControlSignals::*; #(
   parameter   DATA_WIDTH_POW = 6,                      // Using Powers as Parameter ensures width is a power of 2
   localparam  DATA_WIDTH = 1 << DATA_WIDTH_POW
 )(
   input    logic [DATA_WIDTH-1:0]    operand1_in,
   input    logic [DATA_WIDTH-1:0]    operand2_in,
   input    aluOperation_t            aluOp_in,
   
   output   logic [DATA_WIDTH-1:0]    result_out,
   output   logic                     zeroFlag_out
);

   logic                    subEnable;
   logic [DATA_WIDTH-1:0]   operand2Modified;     // inverted version of operand2_in if subtraction is enabled for 2's complement
   logic [DATA_WIDTH-1:0]   orResult;
   logic [DATA_WIDTH-1:0]   andResult;
   logic [DATA_WIDTH-1:0]   adderResult;

   // subEnable and create operand2Modified
   always_comb begin
      subEnable = ~&aluOpcode_in;
      
      operand2Modified = operand2_in ^ {DATA_WIDTH{subEnable}}; // {64{subEnable}} replicates subEnable 64 times to become
   end

   // Full Adder/Subtractor (terminate carry_out)
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
      unique case (aluOp_in)
         OP_SUB:  result_out = adderResult;
         OP_AND:  result_out = andResult;
         OP_OR:   result_out = orResult;
         OP_ADD:  result_out = adderResult;
      endcase
   end

   // zero flag
   always_comb begin
      zeroFlag_out = ~|result_out;
   end

endmodule
