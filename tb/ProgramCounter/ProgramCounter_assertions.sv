module ProgramCounter_assertions #(
   parameter   ADDR_WIDTH_POW = 6,                      // Using Powers as Parameter ensures width is a power of 2
   parameter   ADDR_WIDTH = 1 << ADDR_WIDTH_POW
)(
   input    logic                    clk_in,
   input    logic                    reset,
   input    logic [ADDR_WIDTH-1:0]   instr_in,         // Next Instruction is recieved
   
   output   logic [ADDR_WIDTH-1:0]   instr_out         // Current Instruction is released
);

   ProgramCounter #(.ADDR_WIDTH_POW(ADDR_WIDTH_POW)) DUT (
         .clk_in(clk_in), 
         .reset(reset), 
         .instr_in(instr_in),
			.instr_out(instr_out));

   always_ff @(posedge clk_in) begin
      
      // Asserts that Current Instruction is equal to Past Next Instruction
      assert (instr_out == $past(instr_in));
      
   end

endmodule
