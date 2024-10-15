module ALU_assertions #(
   parameter   DATA_WIDTH_POW = 6,
   parameter   DATA_WIDTH = 1 << DATA_WIDTH_POW
 )(
   input    logic [DATA_WIDTH-1:0]    operand1_in,
   input    logic [DATA_WIDTH-1:0]    operand2_in,
   input    aluOperation_t            aluOp_in,
   
   output   logic [DATA_WIDTH-1:0]    result_out,
   output   logic                     zeroFlag_out
);

   // instantiate DUT
   ALU #(DATA_WIDTH_POW) DUT (.operand1_in, .operand2_in, .aluOp_in, .result_out, .zeroFlag_out);
	
   // Check for addition
   always_comb begin
       if (aluOp_in == OP_ADD) begin
           assert (result_out == operand1_in + operand2_in);
       end
   end

   // Check for subtraction
   always_comb begin
       if (aluOp_in == OP_SUB) begin
           assert (result_out == operand1_in - operand2_in);
       end
   end

   // Check for bitwise AND
   always_comb begin
       if (aluOp_in == OP_AND) begin
           assert (result_out == (operand1_in & operand2_in));
       end
   end

   // Check for bitwise OR
   always_comb begin
       if (aluOp_in == OP_OR) begin
           assert (result_out == (operand1_in | operand2_in));
       end
   end

   // Check for Zero Flag
   always_comb begin
       if (result_out == '0) begin
           assert (zeroFlag_out == 1'b1);
       end
   end

endmodule
