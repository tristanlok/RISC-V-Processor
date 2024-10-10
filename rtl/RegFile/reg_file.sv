module reg_file #(
   parameter   REG_DATA_WIDTH_POW = 6,
   localparam  REG_DATA_WIDTH = 1 << REG_DATA_WIDTH_POW,
   
   parameter   REG_MEM_DEPTH_POW = 5,
   localparam  REG_MEM_DEPTH = 1 << REG_MEM_DEPTH_POW
)(
   input logic [REG_MEM_DEPTH_POW-1:0]    rs1_in, rs2_in,                  // register numbers to read data from
   input logic [REG_MEM_DEPTH_POW-1:0]    rd_in,                           // register number to write data to
   input logic [REG_DATA_WIDTH-1:0]       data_write,                      // data to be written into register
   input logic                            clk_in,
   input logic                            write_en,
   input logic                            reset,

   output logic [REG_DATA_WIDTH-1:0]      reg_data1_out, reg_data2_out    // data output of the two specified registers
);

   logic [REG_DATA_WIDTH-1:0] registers [0:REG_MEM_DEPTH-1]; //= '{default: '0};     // 32 64-bit general registers (casting not supported by symbiyosys

   // Initialize the registers to 0 using an initial block

   initial begin
      for (int i = 0; i < REG_MEM_DEPTH; i = i + 1) begin
         registers[i] = '0; // Initialize each register to all 0's
      end
   end

   // Combinational Logic for decoding register number into register data

   assign reg_data1_out = registers[rs1_in];
   assign reg_data2_out = registers[rs2_in];

   // Sequential Logic for writing data into the target register

   always_ff @(posedge clk_in) begin
      if (reset) begin
         // registers <= '{default: '0};
         
         for (int i = 0; i < REG_MEM_DEPTH; i = i + 1) begin
            registers[i] <= '0; // Initialize each register to all 0's
         end
      
      end else if (write_en && (rd_in != 0)) begin
         registers[rd_in] <= data_write;
      end
   end

   // ONLY USED FOR FORMAL VERIFICATION

   always_ff @(posedge clk_in) begin
      assume(registers[0] == '0);
   end

   // #################################

endmodule
