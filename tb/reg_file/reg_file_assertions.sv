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
   
   output logic [REG_DATA_WIDTH-1:0]       reg_data1_out, reg_data2_out,
);

   // Declare signals to drive the DUT
   

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
      .reg_data1_out(reg_data1_out),
      .reg_data2_out(reg_data2_out)
   );
	
	logic [REG_MEM_DEPTH_POW-1:0]    rd_in_d;
   logic [REG_DATA_WIDTH-1:0]       data_write_d;
   logic 		                    bit_written;
   
   initial begin
		
		//rd_in = 5'b10000;
		/*
		data_write = {REG_DATA_WIDTH{1'b1}};
		rd_in_d = {REG_MEM_DEPTH_POW{1'b0}};
		data_write_d = {REG_DATA_WIDTH{1'b0}};
		write_en = 1'b1;
		*/
		bit_written  = 1'b0;
		rd_in_d      = {REG_MEM_DEPTH_POW{1'b0}};       // Initialize to zero
		data_write_d = {REG_DATA_WIDTH{1'b0}};          // Initialize to zero

   end
	
	always_ff @(posedge clk_in) begin
		assume(rs1_in < REG_MEM_DEPTH); // Constrain register index
		assume(rs2_in < REG_MEM_DEPTH); // Constrain register index
		assume((rd_in > 0) && (rd_in < REG_MEM_DEPTH));  // Constrain write index
		
		assume(write_en == 1'b0 || write_en == 1'b1);  // Ensure write enable is binary
		//assume(data_write < {REG_DATA_WIDTH{1'b1}});  // Randomize or assign reasonable values
	end

   // Read after Write Verification
      
   // Hold all the temporary registers (delayed)
   

   
   always_ff @(posedge clk_in) begin
      if (write_en && (rd_in != 	0)) begin
         rd_in_d <= rd_in;
         data_write_d <= data_write;
         bit_written <= 1'b1;
		end else begin
			bit_written <= 1'b0;
		end
   end
   
   always_ff @(posedge clk_in) begin
      if (bit_written && (rd_in_d == rs1_in)) begin
         assert(reg_data1_out == data_write_d);
      end
   end

   /*
   // No Write without Enable
   
   logic [REG_DATA_WIDTH-1:0]       prev_data = {REG_DATA_WIDTH{1'b0}};
   logic [REG_MEM_DEPTH_POW-1:0]    prev_rd_in = {REG_MEM_DEPTH_POW{1'b0}};
   
   always_ff @(posedge clk_in) begin
      prev_data <= registers[rd_in];
      prev_rd_in <= rd_in;
   end
   
   always_ff @(posedge clk_in) begin
      if (!write_en) begin
         assert(prev_data == registers[prev_rd_in]);
      end
   end
   */
endmodule
