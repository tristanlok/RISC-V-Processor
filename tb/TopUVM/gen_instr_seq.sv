class gen_instr_seq extends uvm_sequence #(uvm_object);
	`uvm_object_utils(gen_instr_seq)
	
	// instruction size and memory depth parameters
	parameter INST_WIDTH = 32;
	parameter MEM_DEPTH = 1024;
	
	logic [INST_WIDTH-1:0] instructions [0:MEM_DEPTH-1];
	
	function new(string name = "gen_instr_seq");
		super.new(name);
	endfunction
	
	// dynamically generate random instructions
	task body();
		foreach (instructions[i]) begin
			instructions[i] = gen_rand_inst();
		end
	endtask
	
	function logic [INST_WIDTH-1:0] gen_rand_inst();
		int inst_type;
		
		inst_type = $random % 4;
		
		unique case (inst_type)
			0: return gen_r_type(7'b0110011);
			1: return gen_i_type(7'b0000011);
			2: return gen_s_type(7'b0100011);
			3: return gen_b_type(7'b1100011);
		endcase

	endfunction
	
	function logic [INST_WIDTH-1:0] gen_r_type (logic[6:0] opcode);
		logic [4:0] rd, rs1, rs2;
		logic [2:0] funct3;
		logic [6:0] funct7;
		
		rd = $random % 32;
		rs1 = $random % 32;
		rs2 = $random % 32;
		
		unique case ($random % 4)
			0: begin
				funct3 = 3'b000;
				funct7 = 7'b0000000;
			end
			1: begin
				funct3 = 3'b000;
				funct7 = 7'b0100000;
			end
			2: begin
				funct3 = 3'b111;
				funct7 = 7'b0000000;
			end
			3: begin
				funct3 = 3'b110;
				funct7 = 7'b0000000;
			end
		endcase
	
		return {funct7, rs2, rs1, funct3, rd, opcode};
	endfunction
	
	function logic [INST_WIDTH-1:0] gen_i_type (logic[6:0] opcode);
		logic [4:0] rd, rs1;
		logic [2:0] funct3;
		logic [11:0] imm;
		
		rd = $random % 32;
		rs1 = $random % 32;
		funct3 = 3'b011;
		imm = $random % 4096;
	
		return {imm, rs1, funct3, rd, opcode};
	endfunction
	
	function logic [INST_WIDTH-1:0] gen_s_type (logic[6:0] opcode);
		logic [4:0] rs1, rs2;
		logic [2:0] funct3;
		logic [11:0] imm;
		
		rs1 = $random % 32;
		rs2 = $random % 32;
		funct3 = 3'b011;
		imm = $random % 4096;
	
		return {imm[11:5], rs2, rs1, imm[4:0], opcode};
	endfunction
	
	function logic [INST_WIDTH-1:0] gen_b_type (logic[6:0] opcode);
		logic [4:0] rs1, rs2;
		logic [2:0] funct3;
		logic [12:0] imm;
		
		rs1 = $random % 32;
		rs2 = $random % 32;
		funct3 = 3'b000;
		imm = $random % 8192;
	
		return {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], opcode};
	endfunction
	
endclass
