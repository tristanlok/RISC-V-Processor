module ControlUnit import temp::*; ( // 1'b0 = OFF 1'b1 = ON
   /* verilator lint_off UNUSEDSIGNAL */
   input logic [31:0]            instruction,
   /* verilator lint_on UNUSEDSIGNAL */
   
   output reg_alu_ctrl_t      reg_alu_mux,
   output logic               mem_read,
   output logic               mem_write,
   output Alu_Operation_t     alu_op,
   output logic               reg_write,
   output data_reg_ctrl_t     data_reg_mux,
   output logic               branch_ctrl
);

// intermediates
logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;

// extract sections from instruction
always_comb begin
   opcode = instruction[6:0];
   funct3 = instruction[14:12];
   funct7 = instruction[31:25];
end   

always_comb begin
   case(opcode)
      7'b0000011: begin //I-TYPE
         // Currently the only instruction supported in I-TYPE is LD
         reg_alu_mux    = IMM_MUX;
         mem_read       = 1'b1;
         mem_write      = 1'b0;
         alu_op         = OP_ADD;
         reg_write      = 1'b1;
         data_reg_mux   = DATA_MEM_MUX;
         branch_ctrl    = 1'b0;
      end
      
      7'b0100011: begin //S-TYPE
         // Currently the only instruction supported in S_TYPE is SD
         reg_alu_mux    = IMM_MUX;
         mem_read       = 1'b0;
         mem_write      = 1'b1;
         alu_op         = OP_ADD;
         reg_write      = 1'b0;
         data_reg_mux   = DATA_ALU_MUX; // Doesn't Matter Which one
         branch_ctrl    = 1'b0;
      end
      
      7'b0110011: begin //R-TYPE
         // Currently supports 4 instructions (ADD, SUB, AND, & OR)
         case (funct3) 
            3'b000: begin
               // Current supports 2 instructions (ADD & SUB)
               case (funct7)
                  7'b0000000: begin
                     // ADD Instruction
                     reg_alu_mux    = REG_MUX;
                     mem_read       = 1'b0;
                     mem_write      = 1'b0;
                     alu_op         = OP_ADD;
                     reg_write      = 1'b1;
                     data_reg_mux   = DATA_ALU_MUX;
                     branch_ctrl    = 1'b0;
                  end
                  
                  7'b0100000: begin
                     // SUB Instruction
                     reg_alu_mux    = REG_MUX;
                     mem_read       = 1'b0;
                     mem_write      = 1'b0;
                     alu_op         = OP_SUB;
                     reg_write      = 1'b1;
                     data_reg_mux   = DATA_ALU_MUX;
                     branch_ctrl    = 1'b0;
                  end
                  
                  default: begin
                     reg_alu_mux    = REG_MUX;
                     mem_read       = 1'b0;
                     mem_write      = 1'b0;
                     alu_op         = OP_AND;
                     reg_write      = 1'b0;
                     data_reg_mux   = DATA_ALU_MUX;
                     branch_ctrl    = 1'b0;
                  end
               endcase
            end
            3'b111: begin
               // AND Instruction
               reg_alu_mux    = REG_MUX;
               mem_read       = 1'b0;
               mem_write      = 1'b0;
               alu_op         = OP_AND;
               reg_write      = 1'b1;
               data_reg_mux   = DATA_ALU_MUX;
               branch_ctrl    = 1'b0;
            end
            
            3'b110: begin
               // OR Instruction
               reg_alu_mux    = REG_MUX;
               mem_read       = 1'b0;
               mem_write      = 1'b0;
               alu_op         = OP_OR;
               reg_write      = 1'b1;
               data_reg_mux   = DATA_ALU_MUX;
               branch_ctrl    = 1'b0;
            end
            
            default: begin
               reg_alu_mux    = REG_MUX;
               mem_read       = 1'b0;
               mem_write      = 1'b0;
               alu_op         = OP_AND;
               reg_write      = 1'b0;
               data_reg_mux   = DATA_ALU_MUX;
               branch_ctrl    = 1'b0;
            end
         endcase
      end
      
      7'b1100011: begin
         // BEQ Instruction
         reg_alu_mux    = REG_MUX;
         mem_read       = 1'b0;
         mem_write      = 1'b0;
         alu_op         = OP_SUB;
         reg_write      = 1'b0;
         data_reg_mux   = DATA_ALU_MUX; // Doesn't Matter Which one
         branch_ctrl    = 1'b1;
      end
      
      default: begin
         reg_alu_mux    = REG_MUX;
         mem_read       = 1'b0;
         mem_write      = 1'b0;
         alu_op         = OP_AND;
         reg_write      = 1'b0;
         data_reg_mux   = DATA_ALU_MUX;
         branch_ctrl    = 1'b0;
      end
   endcase
end
endmodule
