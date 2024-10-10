module DataMemory_assertions #(
   parameter ADDR_WIDTH = 64, //how many bits wide are memory addresses?
   parameter DATA_WIDTH = 64, //how many bits wide is the data bus?
   
   parameter WORD_BYTES_2POW = 3, //how many bytes are in a word? (2^x)
   parameter WORD_BYTES = 1 << WORD_BYTES_2POW, //number of bytes in a word (converted from WORD_BYTES_2POW)
   
   /* verilator lint_off UNUSEDPARAM */ // might be used later
   parameter WORD_WIDTH = WORD_BYTES * 8, //number of bits in a word = no of bytes * 8 bits in a byt
   
   parameter DEPTH_2POW = 6, //how many words are stored in the memory block? (2^x) [CHANGED 12 -> 6 FOR FORMAL VERIFICATION]
   parameter DEPTH = 1 << DEPTH_2POW //number of words stored (converted from DEPTH_2POW)
)
( 
   input logic [ADDR_WIDTH-1:0] address_in, //memory address input
   input logic [DATA_WIDTH-1:0] data_in, //data (to write) input
   input logic writeEnable_in, //enable write
   input logic readEnable_in, //enable read
   input logic clk_in, //clock signal
   input logic reset,
   
   
   output logic [DATA_WIDTH-1:0] data_out //data output (read)
);

   // instantiating DUT
   DataMemory #( 
      .ADDR_WIDTH(ADDR_WIDTH), 
      .DATA_WIDTH(DATA_WIDTH), 
      .WORD_BYTES_2POW(WORD_BYTES_2POW), 
      .WORD_BYTES(WORD_BYTES), 
      .WORD_WIDTH(WORD_WIDTH), 
      .DEPTH_2POW(DEPTH_2POW), 
      .DEPTH(DEPTH)
   ) DUT (
      .address_in(address_in), 
      .data_in(data_in), 
      .writeEnable_in(writeEnable_in), 
      .readEnable_in(readEnable_in), 
      .clk_in(clk_in),
      .reset(reset),
      .data_out(data_out)
   );

   logic [ADDR_WIDTH-1:0] address_in_delay; // delayed memory address input
   logic [DATA_WIDTH-1:0] data_in_delay; // delayed write data input
   logic [DATA_WIDTH-1:0] data_out_delay; // delayed read data output
   
   logic was_written; // whether data was written on the previous cycle
   logic was_reset;   // whether reset was pressed on the previous cycle
   
   
   // initializing delays to 0
   initial begin
   
      address_in_delay = '0;
      data_in_delay = '0;
      data_out_delay = '0;
      was_written = '0;
      was_reset = '0;
   
   end
   
   // assumptions
   always_ff @(posedge clk_in) begin
   
      assume(address_in < (DEPTH * 8)); // constrain size of address to maximum allowed by depth
      assume(writeEnable_in == 1'b0 || writeEnable_in == 1'b1); // ensure writeEnable_in is either 0 or 1
      assume(readEnable_in == 1'b1); // assume read is always on
      
      assume(reset + writeEnable_in < 2);
      
   end
   
   // saving delayed values
   always_ff @(posedge clk_in) begin
      
      address_in_delay <= address_in;
      data_out_delay <= data_out;
      
      if (writeEnable_in) begin
         data_in_delay <= data_in;
         was_written <= 1'b1;
      end else begin
         was_written <= 1'b0;
      end
      
      if (reset) begin
         was_reset <= 1'b1;
      end else begin
         was_reset <= 1'b0;
      end
      
   end
   
   // read after write integrity check
   always_ff @(posedge clk_in) begin
      if (!was_reset && was_written && (address_in_delay == address_in)) begin
         assert (data_out == data_in_delay);
      end
   end
   
   // writeEnable_in low will not write
   always_ff @(posedge clk_in) begin
      if (!was_reset && !was_written && (address_in_delay == address_in)) begin
         assert (data_out_delay == data_out);
      end
   end
   
   // reset behaviour
   always_ff @(posedge clk_in) begin
      if (was_reset) begin
         assert (data_out == '0);
      end
   end
   
endmodule
