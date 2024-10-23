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
   
   output   logic [WORD_SIZE-1:0]   data_out,                     // 8-bit data output (MSB first)
   
   // Output Flags
   output   logic                   outReady_flag,                // FIFO output-ready flag (OR is high when the FIFO is not empty and low when the FIFO is empty)
   output   logic                   inReady_flag,                 // FIFO input-ready flag (IR is high when the FIFO is not full and low when the device is full)
   output   logic                   halfFull_flag                 // FIFO half full flag
);
   // Instantiating SRAM block
   logic [WORD_SIZE-1:0] sram [0:MEM_DEPTH-1];
   
   // Buffer/Latching Register
   logic [WORD_SIZE-1:0] register;
   
   // Memory Pointers (Circular FIFO)
   logic [MEM_DEPTH_POW-1:0]  readPtr;
   logic [MEM_DEPTH_POW-1:0]  writePtr;
   
   // Status-Flag Logic
   
   always_ff @(posedge writeClk_in) begin
      if (!rstN) begin                          // On reset behaviour
         inReady_flag <= '0;
      end else begin
         if ((readPtr-1) == writePtr) begin     // If FIFO is full
            inReady_flag <= '0;
         end else begin
            inReady_flag <= '1;
         end
      end
   end
   
   always_ff @(posedge readClk_in) begin
      if (!rstN) begin                          // On reset behaviour
         outReady_flag <= '0;
      end else begin
         if (readPtr == writePtr) begin         // If FIFO is empty
            outReady_flag <= '0;
         end else begin
            outReady_flag <= '1;
         end
      end
   end
   
   always_comb begin
      if(!rstN) begin                                          // On reset behaviour
         halfFull_flag  = '0;
      end else begin
         if ((writePtr-readPtr) >= (MEM_DEPTH>>1)) begin       // If the difference is equal or greater than half of the depth (16/2)
            halfFull_flag = '1;
         end else begin
            halfFull_flag = '0;
         end
      end
   end
   
   
   // Synchronous Read + Control
   always_ff @(posedge readClk_in) begin
      if (!rstN) begin                                                  // On reset behaviour
         readPtr <= '0;
      end else if (readEn1_in && readEn2_in && !outReady_flag) begin    // If Read Enables are active and FIFO is not empty
         register <= sram[readPtr];                                     // Read current pointer location into register
         if (readPtr >= (WORD_SIZE-1)) begin                            // If read pointer is on the last position, circle back
            readPtr <= '0;
         end else begin
            readPtr <= readPtr + 1;                                     // Increments read pointer by 1
         end
      end
   end
   
   // Synchronous Write + Control
   always_ff @(posedge writeClk_in) begin
      if (!rstN) begin                                                  // On reset behaviour
         writePtr <= '0;
      end else begin
         if (writeEn1_in && writeEn2_in && !inReady_flag) begin         // If Write Enables are active and FIFO is not full
            sram[writePtr] <= data_in;                                  // Write data into current SRAM write location
            if (writePtr >= (WORD_SIZE-1)) begin                        // If write pointer is on the last position, circle back
               writePtr <= '0;
            end else begin
               writePtr <= writePtr + 1;                                // Increments write pointer by 1
            end
         end
      end
   end   
   
   // Tri-state buffer is connected to the data output pins, controlled by Output Enable pin
   assign data_out = (outputEn_in) ? register : 'z;
   
endmodule
