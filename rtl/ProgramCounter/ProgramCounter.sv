module ProgramCounter (
   input    logic          clk_in,
   input    logic          reset,
   input    logic [63:0]   instr_in,         // Next Instruction is recieved
   
   output   logic [63:0]   instr_out         // Current Instruction is released
);

   always_ff @(posedge clk_in) begin
      if (reset) begin                       // Resets back to the first Instruction
         instr_out <= '0;
      end else begin
         instr_out <= instr_in;              // Switches to next Instruction
      end
   end

endmodule
