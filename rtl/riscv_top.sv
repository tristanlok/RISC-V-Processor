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
// SHOULD I PUT THIS IN AN INITIAL BLOCK?
   // Internal net instantiation
   
   // Originates from programCounter
   logic [63:0]   pc_instrMem_addr           =  '0;
   
   // Originates from instrMemory
   logic [31:0]   instrMem_instrDec_instr    =  '0;
   
   // Originates from instrDecoder
   logic [6:0]    opcode   =  '0;
   logic [4:0]    rs1      =  '0;
   logic [4:0]    rs2      =  '0;
   logic [4:0]    rd       =  '0;
   logic [11:0]   imm      =  '0;
   logic [2:0]    funct3   =  '0;
   logic [6:0]    funct7   =  '0;
   
   // Originates from controlUnit
   
   // Originates from regFile
   logic [REG_DATA_WIDTH-1:0]    regFile_ALU_data1    = '0;
   logic [REG_DATA_WIDTH-1:0]    regFile_ALU_data2    = '0;
   
   
   logic [REG_DATA_WIDTH-1:0]    write_data  = '0;
   
   
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

   ControlUnit controlUnit(
      .opcode_in(),
      .funct3_in(),
      .funct7_in(),
      .alu_src_mux(),
      .mem_read(),
      .mem_write(),
      .alu_op(),
      .reg_write(),
      .reg_src_mux(),
      .branch_ctrl()
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
