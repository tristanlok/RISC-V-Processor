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
   
   // Misc.
   logic [63:0]   imm_ext;
   logic [63:0]   mux_alu_data;
   
   // Originates from programCounter
   logic [63:0]   pc_instrMem_addr;
   
   // Originates from instrMemory
   logic [31:0]   instrMem_instrDec_instr;
   
   // Originates from instrDecoder
   logic [6:0]    opcode;
   logic [4:0]    rs1;
   logic [4:0]    rs2;
   logic [4:0]    rd;
   logic [11:0]   imm_12b;
   logic [2:0]    funct3;
   logic [6:0]    funct7;
   
   // Originates from controlUnit
   aluDataSrc_t      aluSrcCtrl;
   logic             memRead;
   logic             memWrite;
   aluOperation_t    aluOp;
   logic             regWrite;
   regDataSrc_t      regSrcCtrl;
   logic             branchCtrl;
   
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
      .imm_out(imm_12b),
      .funct3_out(funct3),
      .funct7_out(funct7)
   );
   
   // Sign-extend IMM
   assign imm_ext = {{(REG_DATA_WIDTH-12){imm_12b[11]}}, imm_12b};      // Replicates imm_12b's MSB [REG_DATA_WIDTH-12] times (currently 52), then concatenates it ahead of imm_12b
   
   ControlUnit controlUnit(
      .opcode_in(opcode),
      .funct3_in(funct3),
      .funct7_in(funct7),
      .aluSrcCtrl_out(aluSrcCtrl),
      .memRead_out(memRead),
      .memWrite_out(memWrite),
      .aluOp_out(aluOp),
      .regWrite_out(regWrite),
      .regSrcCtrl_out(regSrcCtrl),
      .branchCtrl_out(branchCtrl)
   );
   
   RegFile regFile #(
      .REG_DATA_WIDTH_POW(REG_DATA_WIDTH_POW)
   )(
      .clk_in(clk_in),
      .reset(),
      .regWrite_ctrl(),
      .rs1_in(rs1),
      .rs2_in(rs2),
      .rd_in(rd),
      .writeData_in(write_data),
      .regData1_out(regFile_ALU_data1),
      .regData2_out(regFile_ALU_data2)
   );
   
   // MUX to switch between IMM & Register 2 Data
   always_comb begin
      unique case (aluSrcCtrl)
         ALU_SRC_REG: mux_alu_data = regFile_ALU_data2;
         ALU_SRC_IMM: mux_alu_data = imm_ext;
      endcase;
   end      

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
