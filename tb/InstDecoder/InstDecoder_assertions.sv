module InstDecoder_assertions(
   input    logic [31:0]   inst_in,
   
   output   logic [6:0]    opcode,
   output   logic [4:0]    rs1,
   output   logic [4:0]    rs2,
   output   logic [4:0]    rd,
   output   logic [11:0]   imm,
   output   logic [2:0]    funct3,
   output   logic [6:0]    funct7
);

   // Instance of the DUT (Device Under Test)
   InstDecoder DUT (.inst_in, .rs1, .rs2, .rd, .imm, .funct3, .funct7);

   // Assertions for each type of instruction
   always_comb begin
      unique case (inst_in[6:0])
         7'b0000011: begin // I-TYPE
             assert(rd == inst_in[11:7]);
             assert(funct3 == inst_in[14:12]);
             assert(rs1 == inst_in[19:15]);
             assert(imm == inst_in[31:20]);
         end

         7'b0100011: begin // S-TYPE
             assert(rs1 == inst_in[19:15]);
             assert(rs2 == inst_in[24:20]);
             assert(funct3 == inst_in[14:12]);
             assert(imm[4:0] == inst_in[11:7]);
             assert(imm[11:5] == inst_in[31:25]);
         end

         7'b0110011: begin // R-TYPE
             assert(rd == inst_in[11:7]);
             assert(rs1 == inst_in[19:15]);
             assert(rs2 == inst_in[24:20]);
             assert(funct3 == inst_in[14:12]);
             assert(funct7 == inst_in[31:25]);
         end

         7'b1100011: begin // B-TYPE
             assert(rs1 == inst_in[19:15]);
             assert(rs2 == inst_in[24:20]);
             assert(funct3 == inst_in[14:12]);
             assert(imm[3:0] == inst_in[11:8]);
             assert(imm[9:4] == inst_in[30:25]);
             assert(imm[10] == inst_in[7]);
             assert(imm[11] == inst_in[31]);
         end

         default: begin
             // No assertions for unsupported opcodes
         end
     endcase
   end

endmodule
