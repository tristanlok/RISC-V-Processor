module InstrMemory #(
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

   // SIMULATION ONLY: On Initialization, Use $readmemh for hexadecimal format
   /* verilator lint_off UNDRIVEN */
	/*
   initial begin
      $readmemh("", ram); // Load instructions from the file
   end
   */

   // Create the instruction memory
   logic [WORD_SIZE-1:0][7:0] ram [0:MEM_DEPTH - 1]; // Creates MEM_DEPTH number of 32bit rows in memory

   logic [MEM_DEPTH_POW-1:0] wordNumber;

   // calculating word number by dividing mem address by 4
   always_comb begin
      wordNumber = (MEM_DEPTH_POW)'(addr_in >> WORD_SIZE_POW);
   end

   // Assigns the Instruction Data Out
   assign instr_out = ram[wordNumber];
   
endmodule
