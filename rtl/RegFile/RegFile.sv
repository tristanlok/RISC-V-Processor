module RegFile #(
   parameter   REG_DATA_WIDTH_POW = 6,                      // Using Powers as Parameter ensures width is a power of 2
   localparam  REG_DATA_WIDTH = 1 << REG_DATA_WIDTH_POW,
   
   localparam  GEN_REG_COUNT = 32                           // RISC-V only supports 32 General Purpose Registers
)(
   input    logic                         clk_in,
   input    logic                         reset,
   input    logic                         write_en,
   input    logic [4:0]                   rs1_in, rs2_in,                  // register numbers to read data from
   input    logic [4:0]                   rd_in,                           // register number to write data to
   input    logic [REG_DATA_WIDTH-1:0]    write_data_in,                   // data to be written into target register

   output   logic [REG_DATA_WIDTH-1:0]    reg_data1_out, reg_data2_out     // data output of the two specified registers
);

   logic [REG_DATA_WIDTH-1:0] registers [0:GEN_REG_COUNT-1];     // 32 64-bit general registers 
   
   // ONLY USED FOR FORMAL VERIFICATION TO INITIALIZE REGISTERS AS '0
   /*
   initial begin
		// registers = '{default: '0} (casting not supported by symbiyosys)
	
      for (int i = 0; i < GEN_REG_COUNT; i = i + 1) begin
         registers[i] = '0; // Initialize each register to all 0's
      end
   end
   */
   
   // Combinational Logic for decoding register number into register data

   assign reg_data1_out = registers[rs1_in];
   assign reg_data2_out = registers[rs2_in];

   // Sequential Logic for writing data into the target register

   always_ff @(posedge clk_in) begin
      if (reset) begin
         registers <= '{default: '0};
         
         // ONLY USED FOR FORMAL VERIFICATION TO SET REGISTERS AS '0 (casting not supported by symbiyosys)
         /*
         for (int i = 0; i < GEN_REG_COUNT; i = i + 1) begin
            registers[i] <= '0; // Initialize each register to all 0's
         end
         */
      
      end else if (write_en && (rd_in != 0)) begin
         registers[rd_in] <= write_data_in;
      end
   end

   // ONLY USED FOR FORMAL VERIFICATION, DEEP HIERARCHY REFERENCE NOT SUPPORTED BY SYMBIYOSYS
   /*
   always_ff @(posedge clk_in) begin
      assume(registers[0] == '0);
   end
   */
endmodule
