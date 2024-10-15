module InstrDecoder_assertions(
   input    logic [31:0]   instr_in,
   
   output   logic [6:0]    opcode_out,
   output   logic [4:0]    rs1_out,
   output   logic [4:0]    rs2_out,
   output   logic [4:0]    rd_out,
   output   logic [11:0]   imm_out,
   output   logic [2:0]    funct3_out,
   output   logic [6:0]    funct7_out
);

   // Instance of the DUT (Device Under Test)
   InstrDecoder DUT (.instr_in, .opcode_out, .rs1_out, .rs2_out, .rd_out, .imm_out, .funct3_out, .funct7_out);
   
   // Assertion to ensure opcode is correct
   always_comb begin
      assert(opcode_out == instr_in[6:0]);
   end

   // Assertions for each type of instruction
   always_comb begin
      unique case (instr_in[6:0])
         7'b0000011: begin // I-TYPE
             assert(rd_out == instr_in[11:7]);
             assert(funct3_out == instr_in[14:12]);
             assert(rs1_out == instr_in[19:15]);
             assert(imm_out == instr_in[31:20]);
         end

         7'b0100011: begin // S-TYPE
             assert(rs1_out == instr_in[19:15]);
             assert(rs2_out == instr_in[24:20]);
             assert(funct3_out == instr_in[14:12]);
             assert(imm_out[4:0] == instr_in[11:7]);
             assert(imm_out[11:5] == instr_in[31:25]);
         end

         7'b0110011: begin // R-TYPE
             assert(rd_out == instr_in[11:7]);
             assert(rs1_out == instr_in[19:15]);
             assert(rs2_out == instr_in[24:20]);
             assert(funct3_out == instr_in[14:12]);
             assert(funct7_out == instr_in[31:25]);
         end

         7'b1100011: begin // B-TYPE
             assert(rs1_out == instr_in[19:15]);
             assert(rs2_out == instr_in[24:20]);
             assert(funct3_out == instr_in[14:12]);
             assert(imm_out[3:0] == instr_in[11:8]);
             assert(imm_out[9:4] == instr_in[30:25]);
             assert(imm_out[10] == instr_in[7]);
             assert(imm_out[11] == instr_in[31]);
         end

         default: begin
             // No assertions for unsupported opcodes
         end
     endcase
   end

endmodule
