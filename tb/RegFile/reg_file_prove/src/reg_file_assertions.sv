module reg_file_assertions #(
   parameter   REG_DATA_WIDTH_POW = 6,
   localparam  REG_DATA_WIDTH = 1 << REG_DATA_WIDTH_POW,

   parameter   REG_MEM_DEPTH_POW = 5,
   localparam  REG_MEM_DEPTH = 1 << REG_MEM_DEPTH_POW
)(
   input logic [REG_MEM_DEPTH_POW-1:0]    rs1_in, rs2_in,
   input logic [REG_MEM_DEPTH_POW-1:0]    rd_in,
   
   input logic [REG_DATA_WIDTH-1:0]       data_write,
   input logic                            clk_in,
   input logic                            write_en,
   input logic                            reset,
   
   output logic [REG_DATA_WIDTH-1:0]       reg_data1_out, reg_data2_out
);


   // Instantiate the DUT (Design Under Test)
   reg_file #(
      .REG_DATA_WIDTH_POW(REG_DATA_WIDTH_POW),
      .REG_MEM_DEPTH_POW(REG_MEM_DEPTH_POW)
   ) DUT (
      .rs1_in(rs1_in),
      .rs2_in(rs2_in),
      .rd_in(rd_in),
      .data_write(data_write),
      .clk_in(clk_in),
      .write_en(write_en),
		.reset(reset),
      .reg_data1_out(reg_data1_out),
      .reg_data2_out(reg_data2_out)
   );
   
   logic [REG_MEM_DEPTH_POW-1:0]    rs1_in_d; // previous rs1 register
   logic [REG_MEM_DEPTH_POW-1:0]    rs2_in_d; // previous rs2 register
   logic [REG_MEM_DEPTH_POW-1:0]    rd_in_d; // prevous destination register
   logic [REG_DATA_WIDTH-1:0]       data_write_d; // previous data to write
   logic [REG_DATA_WIDTH-1:0]       data_read1_d; // previous data read from rs1
   logic [REG_DATA_WIDTH-1:0]       data_read2_d; // previous data read from rs2
   
   logic                            bit_written; // goes high one cycle after a bit is written
	logic 									was_reset;
   
   initial begin
      
      bit_written  = 1'b0;
      rd_in_d      = '0;       // Initialize to zero
      rs1_in_d      = '0;       // Initialize to zero
      rs2_in_d      = '0;       // Initialize to zero
      data_write_d = '0;          // Initialize to zero
      data_read1_d = '0;         // Initialize to zero
      data_read2_d = '0;          // Initialize to zero
		was_reset = '0;				// Initialize to zero
      
   end
   
   always_ff @(posedge clk_in) begin
      assume(rs1_in < REG_MEM_DEPTH); // Constrain register index
      assume(rs2_in < REG_MEM_DEPTH); // Constrain register index
      assume(rd_in < REG_MEM_DEPTH);  // Constrain write index
      
		assume(reset + write_en < 2);
		
      assume(write_en == 1'b0 || write_en == 1'b1);  // Ensure write enable is binary
   end

   // Saving delayed values
   always_ff @(posedge clk_in) begin
      rd_in_d <= rd_in; // delayed rd_in value
      rs1_in_d <= rs1_in; // delayed rs1_in value
      rs2_in_d <= rs2_in; //delayed rs2_in value
      data_read1_d <= reg_data1_out; // delayed rs1 out
      data_read2_d <= reg_data2_out; // delayed rs2 out
		
		if (reset) begin
			was_reset <= 1'b1;
		end else begin
			was_reset <= 1'b0;
		end
      
      if (write_en && (rd_in != 0)) begin
         data_write_d <= data_write; // delayed written value
         bit_written <= 1'b1;
      end else begin
         bit_written <= 1'b0;
      end
   end
   
   // Note: flatten conditions to avoid state explosioncle
   
   // read after write integrity check
   always_ff @(posedge clk_in) begin
      if (bit_written && (rd_in_d == rs1_in)) begin // bit was written and read reg is same as written reg
         assert(reg_data1_out == data_write_d);
      end
   end
	
	always_ff @(posedge clk_in) begin
		if (bit_written && (rd_in_d == rs2_in)) begin // bit was written and read reg is same as written reg
         assert(reg_data2_out == data_write_d);
      end
	end

   // check write_en low means rd register stays same after 
	
   always_ff @(posedge clk_in) begin
       if (!was_reset && !bit_written && (rs1_in_d == rd_in_d) && (rs1_in == rs1_in_d)) begin // no write and read reg is same as was not written reg
           assert(data_read1_d == reg_data1_out);
       end
   end
	
	always_ff @(posedge clk_in) begin
       if (!was_reset && !bit_written && (rs2_in_d == rd_in_d) && (rs2_in == rs2_in_d)) begin // no write and read reg is same was was not written reg
           assert(data_read2_d == reg_data2_out);
       end
	end
   
   // register zero behaviour
   always_ff @(posedge clk_in) begin
      if (rs1_in == 0) begin // read reg is 0
         assert (reg_data1_out == 0);
      end
   end
	
	always_ff @(posedge clk_in) begin
      if (rs2_in == 0) begin // read reg is 0
         assert (reg_data2_out == 0);
      end
	end
	
	// reset behaviour
	always_ff @(posedge clk_in) begin
		if (was_reset) begin
			assert (reg_data1_out == '0 && reg_data2_out == '0);
		end
	end
	
endmodule
