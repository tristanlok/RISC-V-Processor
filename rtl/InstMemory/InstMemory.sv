module InstMemory #(
   localparam  ADDR_WIDTH = 64,                    // Each Instruction Address is 64bit
   localparam  DATA_WIDTH = 32,                    // Each Instruction Data is 32bit
   
   localparam  WORD_SIZE_POW = 2,                  // Size of Word (in bytes) in terms of power of 2 (4)
   localparam  WORD_SIZE = 1 << WORD_SIZE_POW,     // Size of Word in bytes (1 * 2^2)
   
   parameter   MEM_DEPTH_POW = 10,                 // Default depth of instruction memory 2^10 * 4 = 4 KB
   localparam  MEM_DEPTH = 1 << MEM_DEPTH_POW      // Number of instructions stored in instruction memory   
) 
(
   input		logic [ADDR_WIDTH-1:0] address_in,
   
   output   logic [DATA_WIDTH-1:0] data_out
);

// Create the instruction memory
logic [WORD_SIZE - 1:0][7:0] ram [0:MEM_DEPTH - 1]; // Creates MEM_DEPTH number of 32bit rows in memory

logic [MEM_DEPTH-1:0] wordNumber;

// On Initialization, Use $readmemh for hexadecimal format
initial begin
   $readmemh("", ram); // Load instructions from the file
end

// calculating word number by dividing mem address by 4
always_comb begin
   wordNumber = address_in >> WORD_SIZE_POW;
end

// read instruction  
always_comb begin
   data_out = ram[wordNumber];
end
   
endmodule
