module InstrMemory_assertions #(
   parameter   ADDR_WIDTH_POW = 6,                 // Using Powers as Parameter ensures width is a power of 2
   parameter   ADDR_WIDTH = 1 << ADDR_WIDTH_POW,   // Size of an address
   
   parameter   MEM_DEPTH_POW = 10,                 // Default depth of instruction memory 2^10 * 4 = 4 KB
   parameter   MEM_DEPTH = 1 << MEM_DEPTH_POW,     // Number of instructions stored in instruction memory
   
   parameter   WORD_SIZE_POW = 2,                  // Size of Word (in bytes) in terms of power of 2 (4)
   parameter   WORD_SIZE = 1 << WORD_SIZE_POW      // Size of Word in bytes (1 * 2^2)
) 
(
   input    logic [ADDR_WIDTH-1:0]     addr_in,
   
   output   logic [31:0]               instr_out
);

   // instantiating DUT
   InstrMemory #(
      .MEM_DEPTH_POW(MEM_DEPTH_POW), .ADDR_WIDTH_POW(ADDR_WIDTH_POW)
   ) DUT (
      .addr_in(addr_in),
      .instr_out(instr_out)
   );

   logic [ADDR_WIDTH-1:0] addr_in_delay; // delayed memory address input
   logic [31:0] instr_out_delay; // delayed read data output
   
   logic [WORD_SIZE - 1:0][7:0] expected_values [0:MEM_DEPTH - 1]; // reference memory values
   
   // initializing delays to 0
   initial begin
   
      addr_in_delay = '0;
      instr_out_delay = '0;
      
      $readmemh("", expected_values); // Load instructions from the file
   
   end
   
   // assumptions
   always_comb begin
      assume(addr_in < (MEM_DEPTH * 4)); // constrain size of address to maximum allowed by depth
      
      for (int i = 0; i < MEM_DEPTH; i++) begin
         assume (expected_values[i] == expected_values[i]);
      end
      
   end
   
   // saving delayed values
   always_comb begin
      addr_in_delay <= addr_in;
      
      instr_out_delay <= instr_out;
      
   end
   
   // read integrity check
   always_comb begin
      assert(instr_out == expected_values[addr_in / 4]);
   
   end
   
endmodule
