/*
Synchronous FIFO based on ACT7881

SRAM is configurable through the MEM_DEPTH_POW & WORD_SIZE_POW parameters.
Default SRAM organized in a 16 x 8 bit configuration.
SRAM is implemented using the circular FIFO concept.
*/

module Fifo #(
   parameter   MEM_DEPTH_POW = 4,                  // Default depth of SRAM in terms of power of 2 
   parameter   MEM_DEPTH = 1 << MEM_DEPTH_POW,     // Number of messages that can be stored
   
   parameter   WORD_SIZE_POW = 2,                  // Size of Word (in bits) in terms of power of 2
   parameter   WORD_SIZE = 1 << WORD_SIZE_POW      // Number of bits in each word
) (
   input    logic                   rstN,                         // Active low Reset
   input    logic                   outputEn_in,                  // Output Enable
   input    logic [WORD_SIZE-1:0]   data_in,                      // 8-bit data input (MSB first)
   input    logic                   readClk_in,                   // Free-running Read Clock
   input    logic                   readEn1_in, readEn2_in,       // Read Enables (Both must be active)
   input    logic                   writeClk_in,                  // Free-running Write Clock
   input    logic                   writeEn1_in, writeEn2_in,     // Write Enables (Both must be active)
   input    logic                   dafN_in                       // Active low Define Almost Full
   
   output   logic [WORD_SIZE-1:0]   data_out,                     // 8-bit data output (MSB first)
   
   // Output Flags
   output   logic                   outReady_flag,                // FIFO output-ready flag
   output   logic                   inReady_flag,                 // FIFO input-ready flag
   output   logic                   halfFull_flag,                // FIFO half full flag
   output   logic                   almostFull_flag,              // FIFO almost full flag
   output   logic                   empty_flag                    // FIFO empty flag
);
   // Instantiating SRAM block
   logic [WORD_SIZE-1:0] sram [0:MEM_DEPTH];
   
   // Buffer/Latching Register
   logic [WORD_SIZE-1:0] register;
   
   // Memory Pointers (Circular FIFO)
   logic [MEM_DEPTH_POW-1:0]  readPtr;
   logic [MEM_DEPTH_POW-1:0]  writePtr;
   
   
   // Reset Logic (Reset should be held for 4 clock cycles)
   always_ff @(posedge readClk_in) begin
      if (!rstN) begin
         readPtr <= '0;
      end
   end
   
   always_ff @(posedge writeClk_in) begin
      if (!rstN) begin
         writePtr <= '0;
      end
   end   
   
   // Tri-state buffer is connected to the data output pins, controlled by Output Enable pin
   assign data_out = (outputEn_in) ? register : 'z;
   
endmodule
