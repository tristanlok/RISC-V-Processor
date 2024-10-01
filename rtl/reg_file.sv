module reg_file (
   input [4:0]    rs1_in, rs2_in,                  // register numbers to read data from
   input [4:0]    rd_in,                           // register number to write data to
   input [63:0]   data_write,                      // data to be written into register
   input          clk_in,
   input          write_en,

   output [63:0]  reg_data1_out, reg_data2_out     // data output of the two specified registers
);

reg [63:0] registers [31:0];     // 32 64-bit general registers

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
