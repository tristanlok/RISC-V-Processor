//module ControlUnit_assertions import control_signals::*; ( //COMMENT WHEN DOING FORMAL VERIFICATION
module ControlUnit_assertions ( // UNCOMMENT WHEN DOING FORMAL VERIFICATION
   input    logic [6:0]          opcode_in,
   input    logic [2:0]          funct3_in,
   input    logic [6:0]          funct7_in,
   
   output   Alu_Src_t            alu_src_mux,
   output   logic                mem_read,
   output   logic                mem_write,
   output   Alu_Operation_t      alu_op,
   output   logic                reg_write,
   output   Reg_Data_Src_t       reg_src_mux,
   output   logic                branch_ctrl
);

   ControlUnit DUT (
      .opcode_in(opcode_in),
      .funct3_in(funct3_in),
      .funct7_in(funct7_in),
      .alu_src_mux(alu_src_mux),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .alu_op(alu_op),
      .reg_write(reg_write),
      .reg_src_mux(reg_src_mux),
      .branch_ctrl(branch_ctrl)
   );

   // ld behaviour check
   always_comb begin
      if (opcode_in == 7'b0000011) begin
         assert(alu_src_mux == ALU_SRC_IMM);
         assert(mem_read == 1'b1);
         assert(mem_write == 1'b0);
         assert(alu_op == OP_ADD);
         assert(reg_write == 1'b1);
         assert(reg_src_mux == REG_SRC_MEM);
         assert(branch_ctrl == 1'b0);  
      end
   end
   
   // sd behaviour check
   always_comb begin
      if (opcode_in == 7'b0100011) begin
         assert(alu_src_mux == ALU_SRC_IMM);
         assert(mem_read == 1'b0);
         assert(mem_write == 1'b1);
         assert(alu_op == OP_ADD);
         assert(reg_write == 1'b0);
         //assert(reg_src_mux == REG_SRC_MEM);
         assert(branch_ctrl == 1'b0);
      end
   end
   
   //add behaviour check
   always_comb begin
      if (opcode_in == 7'b0110011 && funct3_in == 3'b000 && funct7_in == 7'b0000000) begin
         assert(alu_src_mux == ALU_SRC_REG);
         assert(mem_read == 1'b0);
         assert(mem_write == 1'b0);
         assert(alu_op == OP_ADD);
         assert(reg_write == 1'b1);
         assert(reg_src_mux == REG_SRC_ALU);
         assert(branch_ctrl == 1'b0);
      end
   end
   
   // sub behaviour check
   always_comb begin
      if (opcode_in == 7'b0110011 && funct3_in == 3'b000 && funct7_in == 7'b0100000) begin
         assert(alu_src_mux == ALU_SRC_REG);
         assert(mem_read == 1'b0);
         assert(mem_write == 1'b0);
         assert(alu_op == OP_SUB);
         assert(reg_write == 1'b1);
         assert(reg_src_mux == REG_SRC_ALU);
         assert(branch_ctrl == 1'b0);
      end
   end
   
   // and behaviour check
   always_comb begin
      if (opcode_in == 7'b0110011 && funct3_in == 3'b111 && funct7_in == 7'b0000000) begin
         assert(alu_src_mux == ALU_SRC_REG);
         assert(mem_read == 1'b0);
         assert(mem_write == 1'b0);
         assert(alu_op == OP_AND);
         assert(reg_write == 1'b1);
         assert(reg_src_mux == REG_SRC_ALU);
         assert(branch_ctrl == 1'b0);
      end
   end
   
   // or behaviour check
   always_comb begin
      if (opcode_in == 7'b0110011 && funct3_in == 3'b110 && funct7_in == 7'b0000000) begin
         assert(alu_src_mux == ALU_SRC_REG);
         assert(mem_read == 1'b0);
         assert(mem_write == 1'b0);
         assert(alu_op == OP_OR);
         assert(reg_write == 1'b1);
         assert(reg_src_mux == REG_SRC_ALU);
         assert(branch_ctrl == 1'b0);
      end
   end
   
   // beq behaviour check
   always_comb begin
      if (opcode_in == 7'b1100011) begin
         assert(alu_src_mux == ALU_SRC_REG);
         assert(mem_read == 1'b0);
         assert(mem_write == 1'b0);
         assert(alu_op == OP_SUB);
         assert(reg_write == 1'b0);
         //assert(reg_src_mux == REG_SRC_ALU);
         assert(branch_ctrl == 1'b1);
      end
   end
endmodule
	