module DataMemory_assertions #(
   parameter   DATA_WIDTH_POW = 6,                    // Using Powers as Parameter ensures width is a power of 2
   parameter   DATA_WIDTH = 1 << DATA_WIDTH_POW,
   
   parameter   ADDR_WIDTH_POW = 6,                    // Using Powers as Parameter ensures width is a power of 2
   parameter   ADDR_WIDTH = 1 << ADDR_WIDTH_POW,
   
   parameter   MEM_DEPTH_POW = 6,                    //how many words are stored in the memory block? (2^x)          [SET 12 -> 6 FOR FASTER VERIFICATION]
   parameter   MEM_DEPTH = 1 << MEM_DEPTH_POW,        //number of words stored (converted from MEM_MEM_DEPTH_POW)
   
   parameter   WORD_BYTES_POW = 3,                    //how many bytes are in a word? (2^x)
   parameter   WORD_BYTES = 1 << WORD_BYTES_POW       //number of bytes in a word (converted from WORD_BYTES_POW)
)(
   input    logic                   clk_in,           //clock signal
   input    logic                   reset,            //reset
   input    logic                   memWrite_ctrl,    //enable write
   input    logic                   memRead_ctrl,     //enable read
   input    logic [ADDR_WIDTH-1:0]  addr_in,          //memory address input
   input    logic [DATA_WIDTH-1:0]  data_in,          //data (to write) input
   
   output   logic [DATA_WIDTH-1:0]  data_out          //data output (read)
);

   // instantiating DUT
   DataMemory #( 
      .DATA_WIDTH_POW(DATA_WIDTH_POW), 
      .ADDR_WIDTH_POW(ADDR_WIDTH_POW), 
      .MEM_DEPTH_POW(MEM_DEPTH_POW)
   ) DUT (
      .addr_in(addr_in), 
      .data_in(data_in), 
      .memWrite_ctrl(memWrite_ctrl), 
      .memRead_ctrl(memRead_ctrl), 
      .clk_in(clk_in),
      .reset(reset),
      .data_out(data_out)
   );

   logic [ADDR_WIDTH-1:0] addr_in_delay; // delayed memory address input
   logic [DATA_WIDTH-1:0] data_in_delay; // delayed write data input
   logic [DATA_WIDTH-1:0] data_out_delay; // delayed read data output
   
   logic was_written; // whether data was written on the previous cycle
   logic was_reset;   // whether reset was pressed on the previous cycle
   
   
   // initializing delays to 0
   initial begin
   
      addr_in_delay = '0;
      data_in_delay = '0;
      data_out_delay = '0;
      was_written = '0;
      was_reset = '0;
   
   end
   
   // assumptions
   always_ff @(posedge clk_in) begin
   
      assume(addr_in < (MEM_DEPTH * 8)); // constrain size of address to maximum allowed by depth
      assume(memWrite_ctrl == 1'b0 || memWrite_ctrl == 1'b1); // ensure memWrite_ctrl is either 0 or 1
      assume(memRead_ctrl == 1'b1); // assume read is always on
      
      assume(reset + memWrite_ctrl < 2);
      
   end
   
   // saving delayed values
   always_ff @(posedge clk_in) begin
      
      addr_in_delay <= addr_in;
      data_out_delay <= data_out;
      
      if (memWrite_ctrl) begin
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
      if (!was_reset && was_written && (addr_in_delay == addr_in)) begin
         assert (data_out == data_in_delay);
      end
   end
   
   // memWrite_ctrl low will not write
   always_ff @(posedge clk_in) begin
      if (!was_reset && !was_written && (addr_in_delay == addr_in)) begin
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
