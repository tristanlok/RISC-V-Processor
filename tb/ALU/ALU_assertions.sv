module ALU_assertions(
    input   logic [63:0]   operand1_in,
    input   logic [63:0]   operand2_in,
    input   logic [2:0]    aluOpcode_in,
    
    output  logic [63:0]   result_out,
    output  logic          zeroFlag_out
);

// instantiate DUT
ALU DUT (.operand1_in, .operand2_in, .aluOpcode_in, .result_out, .zeroFlag_out);

// Check for addition
always_comb begin
    if (aluOpcode_in == OP_ADD) begin
        assert (result_out == operand1_in + operand2_in);
    end
end

// Check for subtraction
always_comb begin
    if (aluOpcode_in == OP_SUB) begin
        assert (result_out == operand1_in - operand2_in);
    end
end

// Check for bitwise AND
always_comb begin
    if (aluOpcode_in == OP_AND) begin
        assert (result_out == (operand1_in & operand2_in));
    end
end

// Check for bitwise OR
always_comb begin
    if (aluOpcode_in == OP_OR) begin
        assert (result_out == (operand1_in | operand2_in));
    end
end

// Check for Zero Flag
always_comb begin
    if (result_out == 64'b0) begin
        assert (zeroFlag_out == 1'b1);
    end
end

endmodule
