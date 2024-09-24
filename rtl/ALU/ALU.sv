/*
Description:
Arithmetic Logic Unit (add, subtract, AND, OR, zero flag)

I/O:
Inputs: operand 1 (64-bit), operand 2 (64-bit), ALU opcode (3-bit)
Outputs: result (64-bit), zero flag (1-bit)

Internal Functions:
1. 64-bit ripple carry adder with subtraction and zero flag output
2. 64-bit bitwise OR and AND
3. Multiplexer to choose output (add, subtract, OR, AND) based on opcode
*/

module ALU(
	input logic [63:0] operand1_in,
	input logic [63:0] operand2_in,
	input logic [2:0] aluOpcode_in,
	output logic [63:0] result_out,
	output logic zeroFlag_out
);

logic subEnable;
logic [63:0] operand2Modified;

logic [63:0] orResult;
logic [63:0] andResult;
logic [63:0] adderResult;

// subEnable and create operand2Modified
always_comb begin

	subEnable = ~&aluOpcode_in;
	
	operand2Modified = operand2_in ^ {64{subEnable}}; // {64{subEnable}} replicates subEnable 64 times to become

end

// Full Adder/Subtractor (terminate carry_out)
/* verilator lint_off PINCONNECTEMPTY */
FullAdder64b FA (.operand1_in(operand1_in), .operand2_in(operand2Modified), 
                 .carry_in(subEnable), .result_out(adderResult), .carry_out());

// bitwise OR
always_comb begin

	orResult = operand1_in | operand2_in;

end

// bitwise AND
always_comb begin

	andResult = operand1_in & operand2_in;

end

// Multiplexer to choose result
always_comb begin
	case(aluOpcode_in)

		3'b000: result_out = adderResult; //SUB
		3'b001: result_out = andResult; //AND
		3'b011: result_out = orResult; //OR
		3'b111: result_out = adderResult; //ADD
		
		//default case right now (full adder)
		default: result_out = adderResult;
		
	endcase
end

// zero flag
always_comb begin

	zeroFlag_out = ~|result_out;

end

// ALU formal assertions
ALU_assertions ALU_check (
    .operand1_in(operand1_in),
    .operand2_in(operand2_in),
    .aluOpcode_in(aluOpcode_in),
    .result_out(result_out),
    .zeroFlag_out(zeroFlag_out)
);

endmodule

