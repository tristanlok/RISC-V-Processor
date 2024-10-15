 module riscv_top import ControlSignals::*; #(
   // Parameters to configure Data Size (32-bit, 64-bit, 128-bit, etc.)
   parameter   DATA_WIDTH_POW = 6,                      // Using Powers as Parameter ensures width is a power of 2
   localparam  DATA_WIDTH = 1 << DATA_WIDTH_POW,
   
   // Parameters to configure Address Size (32-bit, 64-bit, 128-bit, etc.)
   parameter   ADDR_WIDTH_POW = 6,                      // Using Powers as Parameter ensures width is a power of 2
   localparam  ADDR_WIDTH = 1 << ADDR_WIDTH_POW,
   
   // Parameter to configure the depth of Instruction Memory (in terms of powers of 2)
   parameter   INSTR_MEM_DEPTH_POW = 10,
   
   // Parameter to configure the depth of Instruction Memory (in terms of powers of 2)
   parameter   DATA_MEM_DEPTH_POW = 12
 )(
    input   logic    clk_in,
    input   logic    reset
    // add reset and maybe change reset pin names
    
    // ALL I/O CHANGES MUST BE REFLECTED IN FV FILES TOO
    
    // INSTR ALSO CHANGES ALL NAMES
);
   // Internal net instantiation
   
   // Misc.
   logic [DATA_WIDTH-1:0]    imm_ext;
   logic [DATA_WIDTH-1:0]    mux_alu_data;
   logic [DATA_WIDTH-1:0]    mux_reg_data;
   logic                     branch_mux_ctrl;
   
   // Originates from programCounter
   logic [ADDR_WIDTH-1:0]    pc_instrMem_addr;
   
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
   logic [DATA_WIDTH-1:0]    regFile_ALU_data1;
   logic [DATA_WIDTH-1:0]    regFile_data2;
   
   // Originates from ALU
   logic [DATA_WIDTH-1:0]    aluResult;
   logic                     zeroFlag;
   
   // Originates from dataMemory
   logic [DATA_WIDTH-1:0]     dataMem_mux_data;
   
   
   
   
   
   // Module instantiation
   
   // ADD SUPPORT FOR PARAMETERS

   ProgramCounter programCounter(
      .clk_in(clk_in),
      .reset(),
      .instr_in(),
      .instr_out(pc_instrMem_addr)
   );
   
   InstrMemory instrMemory #(
      .ADDR_WIDTH_POW(ADDR_WIDTH_POW),
      .MEM_DEPTH_POW(INSTR_MEM_DEPTH_POW)
   )(
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
   assign imm_ext = {{(DATA_WIDTH-12){imm_12b[11]}}, imm_12b};      // Replicates imm_12b's MSB [DATA_WIDTH-12] times (currently 52), then concatenates it ahead of imm_12b
   
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
      .DATA_WIDTH_POW(DATA_WIDTH_POW)
   )(
      .clk_in(clk_in),
      .reset(),
      .regWrite_ctrl(regWrite),
      .rs1_in(rs1),
      .rs2_in(rs2),
      .rd_in(rd),
      .writeData_in(mux_reg_data),
      .regData1_out(regFile_ALU_data1),
      .regData2_out(regFile_data2)
   );
   
   // MUX to switch between IMM & Register 2 Data
   always_comb begin
      unique case (aluSrcCtrl)
         ALU_SRC_REG: mux_alu_data = regFile_data2;
         ALU_SRC_IMM: mux_alu_data = imm_ext;
      endcase;
   end      

   ALU alu #(
      .DATA_WIDTH_POW(DATA_WIDTH_POW)
   )(
      .operand1_in(regFile_ALU_data1), 
      .operand2_in(mux_alu_data), 
      .aluOp_in(aluOp), 
      .result_out(aluResult), 
      .zeroFlag_out(zeroFlag)
   );
   
   DataMemory dataMemory #(
      .DATA_WIDTH_POW(DATA_WIDTH_POW)
      .ADDR_WIDTH_POW(ADDR_WIDTH_POW),
      .MEM_DEPTH_POW(DATA_MEM_DEPTH_POW)
   )(
      .clk_in(clk_in),
      .reset(),
      .memWrite_ctrl(memWrite),
      .memRead_ctrl(memRead),
      .addr_in(aluResult),
      .data_in(regFile_data2),
      .data_out(dataMem_mux_data)
   );
   
   // MUX to switch between ALU & Data Memory Data
   always_comb begin
      unique case (regSrcCtrl)
         REG_SRC_MEM: mux_reg_data = dataMem_mux_data;
         REG_SRC_ALU: mux_reg_data = aluResult;
      endcase;
   end
   
   // Branch Logic
   assign branch_mux_ctrl = zeroFlag && branchCtrl;
   
endmodule
