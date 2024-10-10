module InstMemory_assertions #(
   parameter ADDR_WIDTH = 64, //how many bits wide are memory addresses?
   parameter DATA_WIDTH = 32, //how many bits wide is the data bus?
   
   parameter WORD_BYTES_2POW = 2, //how many bytes are in a word? (2^x)
   parameter WORD_BYTES = 1 << WORD_BYTES_2POW, //number of bytes in a word (converted from WORD_BYTES_2POW)
   
   parameter DEPTH_2POW = 10, //how many words are stored in the memory block? (2^x)
   parameter DEPTH = 1 << DEPTH_2POW //number of words stored (converted from DEPTH_2POW)
)
( 
   input logic [ADDR_WIDTH-1:0] address_in, //memory address input
   
   output logic [DATA_WIDTH-1:0] data_out //data output (read)
);

   // instantiating DUT
   InstMemory #( 
      .MEM_DEPTH_POW(DEPTH_2POW), 
   ) DUT (
      .address_in(address_in),
      .data_out(data_out)
   );

   logic [ADDR_WIDTH-1:0] address_in_delay; // delayed memory address input
   logic [DATA_WIDTH-1:0] data_out_delay; // delayed read data output
   
   logic [WORD_BYTES - 1:0][7:0] expected_values [0:DEPTH - 1]; // reference memory values
   
   // initializing delays to 0
   initial begin
   
      address_in_delay = '0;
      data_out_delay = '0;
      
      $readmemh("", expected_values); // Load instructions from the file
   
   end
   
   // assumptions
   always_comb begin
      assume(address_in < (DEPTH * 4)); // constrain size of address to maximum allowed by depth
      
      for (int i = 0; i < DEPTH; i++) begin
         assume (expected_values[i] == expected_values[i]);
      end
      
   end
   
   // saving delayed values
   always_comb begin
      address_in_delay <= address_in;
      
      data_out_delay <= data_out;
      
   end
   
   // read integrity check
   always_comb begin
      assert(data_out == expected_values[address_in / 4]);
   
   end
   
endmodule
