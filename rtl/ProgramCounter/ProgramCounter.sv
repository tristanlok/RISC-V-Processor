module ProgramCounter (
   input    logic [63:0]   instruction_i,       // Next Instruction is recieved
   input    logic          clk_in,
   input    logic          reset,
   
   output   logic [63:0]   instruction_o        // Current Instruction is released
);

   always_ff @(posedge clk_in) begin
      if (reset) begin                          // Resets back to the first Instruction
         instruction_o <= '0;
      end else begin
         instruction_o <= instruction_i;        // Switches to next Instruction
      end
   end

endmodule
