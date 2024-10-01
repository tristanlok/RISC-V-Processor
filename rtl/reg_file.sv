module reg_file #(
   parameter   REG_DATA_WIDTH_POW = 6,
   localparam  REG_DATA_WIDTH = 1 << REG_DATA_WIDTH_POW,
   
   parameter   REG_MEM_DEPTH_POW = 5,
   localparam  REG_MEM_DEPTH = 1 << REG_MEM_DEPTH_POW
)(
   input [REG_MEM_DEPTH_POW-1:0]    rs1_in, rs2_in,                  // register numbers to read data from
   input [REG_MEM_DEPTH_POW-1:0]    rd_in,                           // register number to write data to
   input [REG_DATA_WIDTH-1:0]       data_write,                      // data to be written into register
   input                            clk_in,
   input                            write_en,

   output [REG_DATA_WIDTH-1:0]      reg_data1_out, reg_data2_out     // data output of the two specified registers
);

reg [REG_DATA_WIDTH-1:0] registers [REG_MEM_DEPTH-1:0];     // 32 64-bit general registers

// Combinational Logic for decoding register number into register data

assign reg_data1_out = registers[rs1_in];
assign reg_data2_out = registers[rs2_in];

// Sequential Logic for writing data into the target register

always_ff @(posedge clk_in) begin
   if (write_en) begin
      registers[rd_in] <= data_write;
   end
end

endmodule
