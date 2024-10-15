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
   parameter   DATA_WIDTH_POW = 6,                    // Using Powers as Parameter ensures width is a power of 2
   localparam  DATA_WIDTH = 1 << DATA_WIDTH_POW,
   
   parameter   ADDR_WIDTH_POW = 6,                    // Using Powers as Parameter ensures width is a power of 2
   localparam  ADDR_WIDTH = 1 << ADDR_WIDTH_POW,
   
   parameter   MEM_DEPTH_POW = 12,                    //how many words are stored in the memory block? (2^x)
   localparam  MEM_DEPTH = 1 << MEM_DEPTH_POW,        //number of words stored (converted from MEM_MEM_DEPTH_POW)
   
   localparam  WORD_BYTES_POW = 3,                    //how many bytes are in a word? (2^x)
   localparam  WORD_BYTES = 1 << WORD_BYTES_POW       //number of bytes in a word (converted from WORD_BYTES_POW)
)(
   input    logic                   clk_in,           //clock signal
   input    logic                   reset,            //reset
   input    logic                   memWrite_ctrl,    //enable write
   input    logic                   memRead_ctrl,     //enable read
   input    logic [ADDR_WIDTH-1:0]  addr_in,          //memory address input
   input    logic [DATA_WIDTH-1:0]  data_in,          //data (to write) input
   
   output   logic [DATA_WIDTH-1:0]  data_out          //data output (read)
);

   // SIMULATION ONLY: Initialize all memory location sto 0
   /*
   initial begin
      for (int i = 0; i < MEM_DEPTH; i = i + 1) begin
         ram[i] = '0;  // Initialize each register to all 0's
      end
   end
   */

   // intialize ram block
   logic [WORD_BYTES-1:0][7:0] ram [0:MEM_DEPTH-1]; //[number of bytes in a word][number of bits in a byte] ram [number of words (starting at index 0)]

   // internal signals
   logic [MEM_DEPTH_POW-1:0] wordNumber; // which word line to access (taken by dividing memory address by the number of bytes in a word

   // calculate word line number from the memory address
   always_comb begin
      /* verilator lint_off WIDTHTRUNC */ // to implement: check if the calculated wordNumber exceeds the max >MEM_DEPTH-1
      wordNumber = addr_in >> WORD_BYTES_POW; //divide the byte address by the number of bytes in a word to get the wordline nubmer
   end

   // asynchronous reading
   always_comb begin
      /* verilator lint_off UNUSEDPARAM */ // to do: reevaluate necessity of memRead_ctrl | expecing memRead_ctrl = 1
      if(memRead_ctrl) begin
         data_out = ram[wordNumber]; // reads the entire word (word addressable) -> shold be byte addressable in the future
      end else begin
         data_out = '0; // output 0s if memRead_ctrl is not on
      end
   end

   // synchronous writing
   always_ff @(posedge clk_in) begin
      if (reset) begin
         ram <= '{default: '0};
         
         // ONLY USED FOR FORMAL VERIFICATION TO SET REGISTERS AS '0 (casting not supported by symbiyosys)
         /*
         for (int i = 0; i < MEM_DEPTH; i = i + 1) begin
            ram[i] <= '0; // Initialize each register to all 0's
         end
         */
      end else if(memWrite_ctrl) begin
         ram[wordNumber] <= data_in; //writes the entire word to the address -> should be byte addressable in the future (see example below)
      end 
   end
   
endmodule 
