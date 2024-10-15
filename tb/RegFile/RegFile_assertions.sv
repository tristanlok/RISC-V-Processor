module RegFile_assertions #(
   parameter   DATA_WIDTH_POW = 6,                      // Using Powers as Parameter ensures width is a power of 2
   parameter   DATA_WIDTH = 1 << DATA_WIDTH_POW,
   
   parameter   GEN_REG_COUNT = 32                       // RISC-V only supports 32 General Purpose Registers
)(
   input    logic                     clk_in,
   input    logic                     reset,
   input    logic                     regWrite_ctrl,                   // Enable control to write into Register File
   input    logic [4:0]               rs1_in, rs2_in,                  // register numbers to read data from
   input    logic [4:0]               rd_in,                           // register number to write data to
   input    logic [DATA_WIDTH-1:0]    writeData_in,                    // data to be written into target register

   output   logic [DATA_WIDTH-1:0]    regData1_out, regData2_out       // data output of the two specified registers
);

   // Instantiate the DUT (Design Under Test)
   RegFile #(
      .DATA_WIDTH_POW(DATA_WIDTH_POW)
   ) DUT (
      .rs1_in(rs1_in),
      .rs2_in(rs2_in),
      .rd_in(rd_in),
      .writeData_in(writeData_in),
      .clk_in(clk_in),
      .regWrite_ctrl(regWrite_ctrl),
      .reset(reset),
      .regData1_out(regData1_out),
      .regData2_out(regData2_out)
   );
   
   logic [4:0]    rs1_in_d; // previous rs1 register
   logic [4:0]    rs2_in_d; // previous rs2 register
   logic [4:0]    rd_in_d; // prevous destination register
   logic [DATA_WIDTH-1:0]       writeData_in_d; // previous data to write
   logic [DATA_WIDTH-1:0]       data_read1_d; // previous data read from rs1
   logic [DATA_WIDTH-1:0]       data_read2_d; // previous data read from rs2
   
   logic                            bit_written; // goes high one cycle after a bit is written
   logic                            was_reset;
   
   initial begin
      
      bit_written  = 1'b0;
      rd_in_d      = '0;       // Initialize to zero
      rs1_in_d      = '0;       // Initialize to zero
      rs2_in_d      = '0;       // Initialize to zero
      writeData_in_d = '0;          // Initialize to zero
      data_read1_d = '0;         // Initialize to zero
      data_read2_d = '0;          // Initialize to zero
      was_reset = '0;            // Initialize to zero
      
   end
   
   always_ff @(posedge clk_in) begin
      assume(rs1_in < GEN_REG_COUNT); // Constrain register index
      assume(rs2_in < GEN_REG_COUNT); // Constrain register index
      assume(rd_in < GEN_REG_COUNT);  // Constrain write index
      
      assume(reset + regWrite_ctrl < 2);
      
      assume(regWrite_ctrl == 1'b0 || regWrite_ctrl == 1'b1);  // Ensure write enable is binary
   end

   // Saving delayed values
   always_ff @(posedge clk_in) begin
      rd_in_d <= rd_in; // delayed rd_in value
      rs1_in_d <= rs1_in; // delayed rs1_in value
      rs2_in_d <= rs2_in; //delayed rs2_in value
      data_read1_d <= regData1_out; // delayed rs1 out
      data_read2_d <= regData2_out; // delayed rs2 out
      
      if (reset) begin
         was_reset <= 1'b1;
      end else begin
         was_reset <= 1'b0;
      end
      
      if (regWrite_ctrl && (rd_in != 0)) begin
         writeData_in_d <= writeData_in; // delayed written value
         bit_written <= 1'b1;
      end else begin
         bit_written <= 1'b0;
      end
   end
   
   // Note: flatten conditions to avoid state explosioncle
   
   // read after write integrity check
   always_ff @(posedge clk_in) begin
      if (bit_written && (rd_in_d == rs1_in)) begin // bit was written and read reg is same as written reg
         assert(regData1_out == writeData_in_d);
      end
   end
   
   always_ff @(posedge clk_in) begin
      if (bit_written && (rd_in_d == rs2_in)) begin // bit was written and read reg is same as written reg
         assert(regData2_out == writeData_in_d);
      end
   end

   // check regWrite_ctrl low means rd register stays same after 
   
   always_ff @(posedge clk_in) begin
       if (!was_reset && !bit_written && (rs1_in_d == rd_in_d) && (rs1_in == rs1_in_d)) begin // no write and read reg is same as was not written reg
           assert(data_read1_d == regData1_out);
       end
   end
   
   always_ff @(posedge clk_in) begin
       if (!was_reset && !bit_written && (rs2_in_d == rd_in_d) && (rs2_in == rs2_in_d)) begin // no write and read reg is same was was not written reg
           assert(data_read2_d == regData2_out);
       end
   end
   
   // register zero behaviour
   always_ff @(posedge clk_in) begin
      if (rs1_in == 0) begin // read reg is 0
         assert (regData1_out == 0);
      end
   end
   
   always_ff @(posedge clk_in) begin
      if (rs2_in == 0) begin // read reg is 0
         assert (regData2_out == 0);
      end
   end
   
   // reset behaviour
   always_ff @(posedge clk_in) begin
      if (was_reset) begin
         assert (regData1_out == '0 && regData2_out == '0);
      end
   end

endmodule
