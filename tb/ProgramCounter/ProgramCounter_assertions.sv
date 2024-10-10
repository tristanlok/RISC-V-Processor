module ProgramCounter_assertions(
   input    logic [63:0]   instruction_i,
   input    logic          clk_in,
   
   output   logic [63:0]   instruction_o
);

   ProgramCounter DUT (
         .instruction_i(instruction_i), 
         .clk_in(clk_in), 
         .instruction_o(instruction_o));

   always_ff @(posedge clk_in) begin
      
      // Asserts that Current Instruction is equal to Past Next Instruction
      assert (instruction_o == $past(instruction_i));
      
   end

endmodule