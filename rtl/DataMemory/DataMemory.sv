/*
Description:
Data Memory (holds data memory for operations)

I/O:
Inputs: memory address input (64-bit), memory write data input (64-bit), write enable input (1-bit), read enable input (1-bit), clk signal (1-bit)
Outputs: memory read data output (64-bit)

Internal Functions:
1. parameter sized, byte addressable data memory
2. controller receives 64-bit address > divide by 8 (right shift 3) to get word (row) number
3. asynchronous read, synchronous write
*/

/*
Note: right now, only word addressable is implemented, FUTURE: have byteEnable for byte addressability
*/

module DataMemory #(
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
   input logic reset, //clock signal   
   
   output logic [DATA_WIDTH-1:0] data_out //data output (read)
);

   // intialize ram block
   logic [WORD_BYTES-1:0][7:0] ram [0:DEPTH-1]; //[number of bytes in a word][number of bits in a byte] ram [number of words (starting at index 0)]

   // internal signals
   logic [DEPTH_2POW-1:0] wordNumber; // which word line to access (taken by dividing memory address by the number of bytes in a word

   // initialize all memory location sto 0
   initial begin
      for (int i = 0; i < DEPTH; i = i + 1) begin
         ram[i] = '0;  // Initialize each register to all 0's
      end
   end

   // calculate word line number from the memory address
   always_comb begin

      /* verilator lint_off WIDTHTRUNC */ // to implement: check if the calculated wordNumber exceeds the max >DEPTH-1
      wordNumber = address_in >> WORD_BYTES_2POW; //divide the byte address by the number of bytes in a word to get the wordline nubmer

   end

   // asynchronous reading
   always_comb begin

      /* verilator lint_off UNUSEDPARAM */ // to do: reevaluate necessity of readEnable | expecing readEnable = 1
      if(readEnable_in) begin
         data_out = ram[wordNumber]; // reads the entire word (word addressable) -> shold be byte addressable in the future
      end else begin
         data_out = '0; // output 0s if readEnable is not on
      end
      
   end

   // synchronous writing
   always_ff @(posedge clk_in) begin

      if (reset) begin
         // ram <= '{default: '0};
         
         for (int i = 0; i < DEPTH; i = i + 1) begin
            ram[i] <= '0; // Initialize each register to all 0's
         end
      
      end else if(writeEnable_in) begin
         ram[wordNumber] <= data_in; //writes the entire word to the address -> should be byte addressable in the future (see example below)
      end
         
   end
   
endmodule 
