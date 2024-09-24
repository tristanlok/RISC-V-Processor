module ALU_assertions(
    input logic [63:0] operand1_in,
    input logic [63:0] operand2_in,
    input logic [2:0] aluOpcode_in,
    input logic [63:0] result_out,
    input logic zeroFlag_out
);

// Check for addition
always_comb begin
    if (aluOpcode_in == 3'b111) begin
        assert (result_out == operand1_in + operand2_in);
    end
end

// Check for subtraction
always_comb begin
    if (aluOpcode_in == 3'b000) begin
        assert (result_out == operand1_in - operand2_in);
    end
end

// Check for bitwise AND
always_comb begin
    if (aluOpcode_in == 3'b001) begin
        assert (result_out == (operand1_in & operand2_in));
    end
end

// Check for bitwise OR
always_comb begin
    if (aluOpcode_in == 3'b011) begin
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
