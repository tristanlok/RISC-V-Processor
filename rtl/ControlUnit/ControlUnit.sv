// FOR FORMAL VERIFICATION ONLY | SYMBIYOSYS DOES NOT SUPPORT PACKAGES
/*
typedef enum logic [2:0] {
   OP_ADD = 3'b111,  
   OP_SUB = 3'b000,  
   OP_AND = 3'b001,
   OP_OR  = 3'b011 
} Alu_Operation_t;

typedef enum logic {
   ALU_SRC_REG, 
   ALU_SRC_IMM  
} Alu_Src_t;

typedef enum logic {
   REG_SRC_MEM,  
   REG_SRC_ALU   
} Reg_Data_Src_t;

module ControlUnit( 

*/

module ControlUnit import ControlSignals::*; ( // 1'b0 = OFF 1'b1 = ON
   input    logic [6:0]          opcode_in,
   input    logic [2:0]          funct3_in,
   input    logic [6:0]          funct7_in,
   
   output   Alu_Src_t            alu_src_mux_ctrl,
   output   logic                mem_read,
   output   logic                mem_write,
   output   Alu_Operation_t      alu_op,
   output   logic                reg_write,
   output   Reg_Data_Src_t       reg_src_mux_ctrl,
   output   logic                branch_ctrl
);

   always_comb begin
      unique case(opcode_in)
         7'b0000011: begin //I-TYPE
            // LD Instruction
            alu_src_mux_ctrl  = ALU_SRC_IMM;
            mem_read          = 1'b1;
            mem_write         = 1'b0;
            alu_op            = OP_ADD;
            reg_write         = 1'b1;
            reg_src_mux_ctrl  = REG_SRC_MEM;
            branch_ctrl       = 1'b0;
         end
         
         7'b0100011: begin //S-TYPE
            // SD Instruction
            alu_src_mux_ctrl  = ALU_SRC_IMM;
            mem_read          = 1'b0;
            mem_write         = 1'b1;
            alu_op            = OP_ADD;
            reg_write         = 1'b0;
            reg_src_mux_ctrl  = REG_SRC_ALU; // Doesn't matter which one
            branch_ctrl       = 1'b0;
         end
         
         7'b0110011: begin //R-TYPE
            // Currently supports 4 instructions (ADD, SUB, AND, & OR)
            unique case (funct3_in) 
               3'b000: begin
                  // Current supports 2 instructions (ADD & SUB)
                  case (funct7_in)
                     7'b0000000: begin
                        // ADD Instruction
                        alu_src_mux_ctrl  = ALU_SRC_REG;
                        mem_read          = 1'b0;
                        mem_write         = 1'b0;
                        alu_op            = OP_ADD;
                        reg_write         = 1'b1;
                        reg_src_mux_ctrl  = REG_SRC_ALU;
                        branch_ctrl       = 1'b0;
                     end
                     
                     7'b0100000: begin
                        // SUB Instruction
                        alu_src_mux_ctrl  = ALU_SRC_REG;
                        mem_read          = 1'b0;
                        mem_write         = 1'b0;
                        alu_op            = OP_SUB;
                        reg_write         = 1'b1;
                        reg_src_mux_ctrl  = REG_SRC_ALU;
                        branch_ctrl       = 1'b0;
                     end
                  endcase
               end
               3'b111: begin
                  // AND Instruction
                  alu_src_mux_ctrl  = ALU_SRC_REG;
                  mem_read          = 1'b0;
                  mem_write         = 1'b0;
                  alu_op            = OP_AND;
                  reg_write         = 1'b1;
                  reg_src_mux_ctrl  = REG_SRC_ALU;
                  branch_ctrl       = 1'b0;
               end
               
               3'b110: begin
                  // OR Instruction
                  alu_src_mux_ctrl  = ALU_SRC_REG;
                  mem_read          = 1'b0;
                  mem_write         = 1'b0;
                  alu_op            = OP_OR;
                  reg_write         = 1'b1;
                  reg_src_mux_ctrl  = REG_SRC_ALU;
                  branch_ctrl       = 1'b0;
               end
            endcase
         end
         
         7'b1100011: begin //B-TYPE
            // BEQ Instruction
            alu_src_mux_ctrl  = ALU_SRC_REG;
            mem_read          = 1'b0;
            mem_write         = 1'b0;
            alu_op            = OP_SUB;
            reg_write         = 1'b0;
            reg_src_mux_ctrl  = REG_SRC_ALU; // Doesn't matter which one
            branch_ctrl       = 1'b1;
         end
      endcase
   end
endmodule
