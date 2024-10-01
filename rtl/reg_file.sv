module reg_file (
   input [4:0]    rs1_in, rs2_in,                  // register numbers to read data from
   input [4:0]    write_reg_num_in,                // register number to write data to
   input [63:0]   reg_write,                       // data to be written into register
   input          clk_in,
   input          write_en,

   output [63:0]  reg_data1_out, reg_data2_out     // data output of the two specified registers
);

reg [63:0] registers [31:0];     // 32 64-bit general registers

// Combinational Logic for decoding register number into register data

assign reg_data_1 = registers[reg_num_1];
assign reg_data_2 = registers[reg_num_2];

// Sequential Logic for writing data into the target register

always_ff @(posedge clk) begin
   if (write_en) begin
      registers[write_reg] <= write_data;
   end
end

endmodule
