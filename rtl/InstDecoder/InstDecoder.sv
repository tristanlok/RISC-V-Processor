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

module InstDecoder(
   input logic [31:0] inst_in,
   output logic [6:0] opcode,
   output logic [4:0] rs1,
   output logic [4:0] rs2,
   output logic [4:0] rd,
   output logic [11:0] imm,
   output logic [2:0] funct3,
   output logic [6:0] funct7
);

// extract opcode from instruction
always_comb begin

   opcode = inst_in[6:0];

end   

// extract format agnostic information
always_comb begin
   
   /* verilator lint_off CASEINCOMPLETE */
   // switch type based on opcode
   unique case(inst_in[6:0])
   
      7'b0000011: begin //I-TYPE
         rd = inst_in[11:7];
         funct3 = inst_in[14:12];
         rs1 = inst_in[19:15];
         imm = inst_in[31:20];
			
			rs2 = 5'bx; // Dont Care
			funct7 = 7'bx; // Dont Care
      end
      
      7'b0100011: begin //S-TYPE
         imm[4:0] = inst_in[11:7];
         funct3 = inst_in[14:12];
         rs1 = inst_in[19:15];
         rs2 = inst_in[24:20];
         imm[11:5] = inst_in[31:25];
			
			rd = 5'bx; // Dont Care
			funct7 = 7'bx; // Dont Care
      end
      
      7'b0110011: begin //R-TYPE
         rd = inst_in[11:7];
         funct3 = inst_in[14:12];
         rs1 = inst_in[19:15];
         rs2 = inst_in[24:20];
         funct7 = inst_in[31:25];
			
			imm = 12'bx; // DOnt Care
      end
      
      7'b1100011: begin //B-TYPE //NOTE: imm for B-type is technically 13-bits because its left shift 
                                 //by 1 but that will be handled outside of instruction decoder
         imm[10] = inst_in[7];
         imm[3:0] = inst_in[11:8];
         funct3 = inst_in[14:12];
         rs1 = inst_in[19:15];
         rs2 = inst_in[24:20];
         imm[9:4] = inst_in[30:25];
         imm[11] = inst_in[31];
			
			rd = 5'bx; // Dont Care
			funct7 = 7'bx; // Dont Care
      end
		
		default : begin //Default - set everything to dont care
			rs1 = 5'bx;
			rs2 = 5'bx;
			rd = 5'bx;
			imm = 12'bx;
			funct3 = 3'bx;
			funct7 = 7'bx;
		end
      
   endcase

end
   
endmodule
