// FOR FORMAL VERIFICATION ONLY | SYMBIYOSYS DOES NOT SUPPORT PACKAGES
/*
typedef enum logic [2:0] {
   OP_ADD = 3'b111,
   OP_SUB = 3'b000,
   OP_AND = 3'b001,
   OP_OR  = 3'b011
} aluOperation_t;

typedef enum logic {
   ALU_SRC_REG,
   ALU_SRC_IMM
} aluDataSrc_t;

typedef enum logic {
   REG_SRC_MEM,
   REG_SRC_ALU
} regDataSrc_t;

module ControlUnit( 
*/

module ControlUnit import ControlSignals::*; ( // 1'b0 = OFF 1'b1 = ON
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

   always_comb begin
	
		/* verilator lint_off CASEINCOMPLETE */
      unique case(opcode_in)
         7'b0000011: begin //I-TYPE
            // LD Instruction
            aluSrcCtrl_out    = ALU_SRC_IMM;
            memRead_out       = 1'b1;
            memWrite_out      = 1'b0;
            aluOp_out         = OP_ADD;
            regWrite_out      = 1'b1;
            regSrcCtrl_out    = REG_SRC_MEM;
            branchCtrl_out    = 1'b0;
         end
         
         7'b0100011: begin //S-TYPE
            // SD Instruction
            aluSrcCtrl_out    = ALU_SRC_IMM;
            memRead_out       = 1'b0;
            memWrite_out      = 1'b1;
            aluOp_out         = OP_ADD;
            regWrite_out      = 1'b0;
            regSrcCtrl_out    = REG_SRC_ALU; // Doesn't matter which one
            branchCtrl_out    = 1'b0;
         end
         
         7'b0110011: begin //R-TYPE
            // Currently supports 4 instructions (ADD, SUB, AND, & OR)
            unique case (funct3_in) 
               3'b000: begin
                  // Current supports 2 instructions (ADD & SUB)
                  unique case (funct7_in)
                     7'b0000000: begin
                        // ADD Instruction
                        aluSrcCtrl_out    = ALU_SRC_REG;
                        memRead_out       = 1'b0;
                        memWrite_out      = 1'b0;
                        aluOp_out         = OP_ADD;
                        regWrite_out      = 1'b1;
                        regSrcCtrl_out    = REG_SRC_ALU;
                        branchCtrl_out    = 1'b0;
                     end
                     
                     7'b0100000: begin
                        // SUB Instruction
                        aluSrcCtrl_out    = ALU_SRC_REG;
                        memRead_out       = 1'b0;
                        memWrite_out      = 1'b0;
                        aluOp_out         = OP_SUB;
                        regWrite_out      = 1'b1;
                        regSrcCtrl_out    = REG_SRC_ALU;
                        branchCtrl_out    = 1'b0;
                     end
                  endcase
               end
               3'b111: begin
                  // AND Instruction
                  aluSrcCtrl_out    = ALU_SRC_REG;
                  memRead_out       = 1'b0;
                  memWrite_out      = 1'b0;
                  aluOp_out         = OP_AND;
                  regWrite_out      = 1'b1;
                  regSrcCtrl_out    = REG_SRC_ALU;
                  branchCtrl_out    = 1'b0;
               end
               
               3'b110: begin
                  // OR Instruction
                  aluSrcCtrl_out    = ALU_SRC_REG;
                  memRead_out       = 1'b0;
                  memWrite_out      = 1'b0;
                  aluOp_out         = OP_OR;
                  regWrite_out      = 1'b1;
                  regSrcCtrl_out    = REG_SRC_ALU;
                  branchCtrl_out    = 1'b0;
               end
            endcase
         end
         
         7'b1100011: begin //B-TYPE
            // BEQ Instruction
            aluSrcCtrl_out    = ALU_SRC_REG;
            memRead_out       = 1'b0;
            memWrite_out      = 1'b0;
            aluOp_out         = OP_SUB;
            regWrite_out      = 1'b0;
            regSrcCtrl_out    = REG_SRC_ALU; // Doesn't matter which one
            branchCtrl_out    = 1'b1;
         end
      endcase
   end
endmodule
