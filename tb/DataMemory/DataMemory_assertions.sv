module DataMemory_assertions #(
	parameter ADDR_WIDTH = 64, //how many bits wide are memory addresses?
   parameter DATA_WIDTH = 64, //how many bits wide is the data bus?
   
   parameter WORD_BYTES_2POW = 3, //how many bytes are in a word? (2^x)
   parameter WORD_BYTES = 1 << WORD_BYTES_2POW, //number of bytes in a word (converted from WORD_BYTES_2POW)
   
   /* verilator lint_off UNUSEDPARAM */ // might be used later
   parameter WORD_WIDTH = WORD_BYTES * 8, //number of bits in a word = no of bytes * 8 bits in a byt
   
   parameter DEPTH_2POW = 12, //how many words are stored in the memory block? (2^x)
   parameter DEPTH = 1 << DEPTH_2POW //number of words stored (converted from DEPTH_2POW)
)
( 
   input logic [ADDR_WIDTH-1:0] address_in, //memory address input
   input logic [DATA_WIDTH-1:0] data_in, //data (to write) input
   input logic writeEnable_in, //enable write
   input logic readEnable_in, //enable read
   input logic clk_in, //clock signal
   output logic [DATA_WIDTH-1:0] data_out //data output (read)
);

// instantiating DUT
DataMemory #( .ADDR_WIDTH, .DATA_WIDTH, .WORD_BYTES_2POW, .WORD_BYTES, .WORD_WIDTH, .DEPTH_2POW, .DEPTH) 
DUT (.address_in, .data_in., writeEnable_in, .readEnable_in, .clk_in, .data_out);



endmodule