package control_signals;

   // Enum to represent ALU operations (Add, Subtract, AND, OR)
   typedef enum logic [2:0] {
      OP_ADD = 3'b111,  // ALU operation: Add
      OP_SUB = 3'b000,  // ALU operation: Subtract
      OP_AND = 3'b001,  // ALU operation: AND
      OP_OR  = 3'b011   // ALU operation: OR
   } Alu_Operation_t;

   // Enum to control the source of the ALU operand (Register or Immediate)
   typedef enum logic {
      ALU_SRC_REG,  // ALU input source: Register
      ALU_SRC_IMM   // ALU input source: Immediate
   } Alu_Src_t;

   // Enum to control the source of data for the register (Data from memory or ALU)
   typedef enum logic {
      REG_SRC_MEM,  // Register data source: Data from memory
      REG_SRC_ALU   // Register data source: Data from ALU
   } Reg_Data_Src_t;

endpackage
