module ProgramCounter #(
   parameter   ADDR_WIDTH_POW = 6,                      // Using Powers as Parameter ensures width is a power of 2
   localparam  ADDR_WIDTH = 1 << ADDR_WIDTH_POW,
)(
   input    logic                    clk_in,
   input    logic                    reset,
   input    logic [ADDR_WIDTH-1:0]   instr_in,         // Next Instruction is recieved
   
   output   logic [ADDR_WIDTH-1:0]   instr_out         // Current Instruction is released
);

   always_ff @(posedge clk_in) begin
      if (reset) begin                       // Resets back to the first Instruction
         instr_out <= '0;
      end else begin
         instr_out <= instr_in;              // Switches to next Instruction
      end
   end

endmodule
