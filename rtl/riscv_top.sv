 module riscv_top import ControlSignals::*; (
    input   logic       clk_in
);

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
   
   InstDecoder instDecoder(
      .inst_in(),
      .rs1(),
      .rs2(),
      .rd(),
      .imm(),
      .funct3(),
      .funct7()
   );
   
   InstMemory instMemory(
      .address_in(),
      .data_out()
   );
      
   ProgramCounter programCounter(
      .instrunction_i(),
      .clk_in(),
      .reset(),
      .instruction_o()
   );
   
   RegFile regFile(
      .rs1_in(),
      .rs2_in(),
      .rd_in(),
      .data_write(),
      .clk_in(),
      .write_en(),
      .reset(),
      .reg_data1_out(),
      .reg_data2_out()
   ); 
   
endmodule
