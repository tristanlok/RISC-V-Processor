module ControlUnit_assertions (
   input    logic [6:0]          opcode_in,
   input    logic [2:0]          funct3_in,
   input    logic [6:0]          funct7_in,
   
   output   aluDataSrc_t         aluSrcCtrl_out,
   output   logic                memRead_out,
   output   logic                memWrite_out,
   output   aluOperation_t       aluOp_out,
   output   logic                regWrite_out,
   output   regDataSrc_t         regSrcCtrl_out,
   output   logic                branchCtrl_out
);

   ControlUnit DUT (
      .opcode_in(opcode_in),
      .funct3_in(funct3_in),
      .funct7_in(funct7_in),
      .aluSrcCtrl_out(aluSrcCtrl_out),
      .memRead_out(memRead_out),
      .memWrite_out(memWrite_out),
      .aluOp_out(aluOp_out),
      .regWrite_out(regWrite_out),
      .regSrcCtrl_out(regSrcCtrl_out),
      .branchCtrl_out(branchCtrl_out)
   );

   // ld behaviour check
   always_comb begin
      if (opcode_in == 7'b0000011) begin
         assert(aluSrcCtrl_out == ALU_SRC_IMM);
         assert(memRead_out == 1'b1);
         assert(memWrite_out == 1'b0);
         assert(aluOp_out == OP_ADD);
         assert(regWrite_out == 1'b1);
         assert(regSrcCtrl_out == REG_SRC_MEM);
         assert(branchCtrl_out == 1'b0);  
      end
   end
   
   // sd behaviour check
   always_comb begin
      if (opcode_in == 7'b0100011) begin
         assert(aluSrcCtrl_out == ALU_SRC_IMM);
         assert(memRead_out == 1'b0);
         assert(memWrite_out == 1'b1);
         assert(aluOp_out == OP_ADD);
         assert(regWrite_out == 1'b0);
         //assert(regSrcCtrl_out == REG_SRC_MEM);
         assert(branchCtrl_out == 1'b0);
      end
   end
   
   //add behaviour check
   always_comb begin
      if (opcode_in == 7'b0110011 && funct3_in == 3'b000 && funct7_in == 7'b0000000) begin
         assert(aluSrcCtrl_out == ALU_SRC_REG);
         assert(memRead_out == 1'b0);
         assert(memWrite_out == 1'b0);
         assert(aluOp_out == OP_ADD);
         assert(regWrite_out == 1'b1);
         assert(regSrcCtrl_out == REG_SRC_ALU);
         assert(branchCtrl_out == 1'b0);
      end
   end
   
   // sub behaviour check
   always_comb begin
      if (opcode_in == 7'b0110011 && funct3_in == 3'b000 && funct7_in == 7'b0100000) begin
         assert(aluSrcCtrl_out == ALU_SRC_REG);
         assert(memRead_out == 1'b0);
         assert(memWrite_out == 1'b0);
         assert(aluOp_out == OP_SUB);
         assert(regWrite_out == 1'b1);
         assert(regSrcCtrl_out == REG_SRC_ALU);
         assert(branchCtrl_out == 1'b0);
      end
   end
   
   // and behaviour check
   always_comb begin
      if (opcode_in == 7'b0110011 && funct3_in == 3'b111 && funct7_in == 7'b0000000) begin
         assert(aluSrcCtrl_out == ALU_SRC_REG);
         assert(memRead_out == 1'b0);
         assert(memWrite_out == 1'b0);
         assert(aluOp_out == OP_AND);
         assert(regWrite_out == 1'b1);
         assert(regSrcCtrl_out == REG_SRC_ALU);
         assert(branchCtrl_out == 1'b0);
      end
   end
   
   // or behaviour check
   always_comb begin
      if (opcode_in == 7'b0110011 && funct3_in == 3'b110 && funct7_in == 7'b0000000) begin
         assert(aluSrcCtrl_out == ALU_SRC_REG);
         assert(memRead_out == 1'b0);
         assert(memWrite_out == 1'b0);
         assert(aluOp_out == OP_OR);
         assert(regWrite_out == 1'b1);
         assert(regSrcCtrl_out == REG_SRC_ALU);
         assert(branchCtrl_out == 1'b0);
      end
   end
   
   // beq behaviour check
   always_comb begin
      if (opcode_in == 7'b1100011) begin
         assert(aluSrcCtrl_out == ALU_SRC_REG);
         assert(memRead_out == 1'b0);
         assert(memWrite_out == 1'b0);
         assert(aluOp_out == OP_SUB);
         assert(regWrite_out == 1'b0);
         //assert(regSrcCtrl_out == REG_SRC_ALU);
         assert(branchCtrl_out == 1'b1);
      end
   end
endmodule
	