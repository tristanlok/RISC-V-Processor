 module riscv_top import ControlSignals::*; #(
   // Parameters to configure Register Size (32-bit, 64-bit, 128-bit, etc.)
   parameter   REG_DATA_WIDTH_POW = 6,                      // Using Powers as Parameter ensures width is a power of 2
   localparam  REG_DATA_WIDTH = 1 << REG_DATA_WIDTH_POW,
 )(
    input   logic       clk_in
    // add reset and maybe change reset pin names
    
    // ALL I/O CHANGES MUST BE REFLECTED IN FV FILES TOO
    
    // INSTR ALSO CHANGES ALL NAMES
);
   // Internal net instantiation
   
   // Originates from programCounter
   logic [63:0]   pc_instrMem_addr;
   
   // Originates from instrMemory
   logic [31:0]   instrMem_instrDec_instr;
   
   // Originates from instrDecoder
   logic [6:0]    opcode;
   logic [4:0]    rs1;
   logic [4:0]    rs2;
   logic [4:0]    rd;
   logic [11:0]   imm;
   logic [2:0]    funct3;
   logic [6:0]    funct7;
   
   // Originates from controlUnit
	
	Alu_Src_t	
   
   // Originates from regFile
   logic [REG_DATA_WIDTH-1:0]    regFile_ALU_data1;
   logic [REG_DATA_WIDTH-1:0]    regFile_ALU_data2;
   
   
   logic [REG_DATA_WIDTH-1:0]    write_data;
   
   
   // Module instantiation
   
   // ADD SUPPORT FOR PARAMETERS

   ProgramCounter programCounter(
      .clk_in(clk_in),
      .reset(),
      .instr_in(),
      .instr_out(pc_instrMem_addr)
   );
   
   InstrMemory instrMemory(
      .addr_in(pc_instrMem_addr),
      .instr_out(instrMem_instrDec_instr)
   );
   
   InstrDecoder instrDecoder(
      .instr_in(instrMem_instrDec_instr),
      .opcode_out(opcode),
      .rs1_out(rs1),
      .rs2_out(rs2),
      .rd_out(rd),
      .imm_out(imm),
      .funct3_out(funct3),
      .funct7_out(funct7)
   );
	
	ControlUnit controlUnit(
      .opcode_in(),
      .funct3_in(),
      .funct7_in(),
      .alu_src_mux_ctrl(),
      .mem_read(),
      .mem_write(),
      .alu_op(),
      .reg_write(),
      .reg_src_mux_ctrl(),
      .branch_ctrl()
   );
   
   RegFile regFile #(
      .REG_DATA_WIDTH_POW(REG_DATA_WIDTH_POW)
   )(
      .clk_in(clk_in),
      .reset(),
      .write_en(),
      .rs1_in(rs1),
      .rs2_in(rs2),
      .rd_in(rd),
      .write_data_in(write_data),
      .reg_data1_out(regFile_ALU_data1),
      .reg_data2_out(regFile_ALU_data2)
   );
   
   unique case (/*expression*/)     // MUX to switch between IMM & Register 2 Data
      

   ALU alu (
      .operand1_in(), 
      .operand2_in(), 
      .aluOpcode_in(), 
      .result_out(), 
      .zeroFlag_out()
   );
   
   DataMemory dataMemory(
      .address_in(),
      .data_in(),
      .writeEnable_in(),
      .readEnable_in(),
      .clk_in(),
      .reset()
   );
   
   
   
endmodule
