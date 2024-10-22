/*
Description:
Extracts relevant information from 32-bit instructions

I/O:
Inputs: instruction (32-bit)
Outputs: rs1 (5-bit), rs2 (5-bit), rd (5-bit), imm (12-bit), funct3 (3-bit), funct7 (7-bit)

Internal Functions:
1. Combination logic to split data appropriately
*/
/*
Note: currently only supports necesary instruction types (I, S, R, B)
*/

module InstrDecoder(
   input    logic [31:0]   instr_in,
   
   output   logic [6:0]    opcode_out,
   output   logic [4:0]    rs1_out,
   output   logic [4:0]    rs2_out,
   output   logic [4:0]    rd_out,
   output   logic [11:0]   imm_out,
   output   logic [2:0]    funct3_out,
   output   logic [6:0]    funct7_out
);

   // extract opcode from instruction
   always_comb begin
      opcode_out = instr_in[6:0];
   end   

   // extract format agnostic information
   always_comb begin
   
		/* verilator lint_off CASEINCOMPLETE */
      // switch type based on opcode
      unique case(instr_in[6:0])
      
         7'b0000011: begin //I-TYPE
            rd_out      = instr_in[11:7];
            funct3_out  = instr_in[14:12];
            rs1_out     = instr_in[19:15];
            imm_out     = instr_in[31:20];
            
            // Don't Care
            rs2_out     = '0;
            funct7_out  = '0;
         end
         
         7'b0100011: begin //S-TYPE
            funct3_out  = instr_in[14:12];
            rs1_out     = instr_in[19:15];
            rs2_out     = instr_in[24:20];
            imm_out     = {instr_in[31:25], instr_in[11:7]};
            
            // Don't Care
            rd_out         = '0;
            funct7_out     = '0;
         end
         
         7'b0110011: begin //R-TYPE
            rd_out      = instr_in[11:7];
            funct3_out  = instr_in[14:12];
            rs1_out     = instr_in[19:15];
            rs2_out     = instr_in[24:20];
            funct7_out  = instr_in[31:25];
            
            // Don't Care
            imm_out     = '0;
         end
         
         7'b1100011: begin //B-TYPE //NOTE: imm for B-type is technically 13-bits because its left shift 
                                    //by 1 but that will be handled outside of instruction decoder
            funct3_out  = instr_in[14:12];
            rs1_out     = instr_in[19:15];
            rs2_out     = instr_in[24:20];
            imm_out     = {instr_in[31], instr_in[7], instr_in[30:25], instr_in[11:8]};
            
            // Don't Care
            rd_out      = '0;
            funct7_out  = '0;
         end         
      endcase
   end
endmodule
