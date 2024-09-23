module reg_file (
	input [4:0] 	reg_num_1, reg_num_2,
	input [4:0]		write_reg,
	input [63:0]	write_data,
	input 			clk,
	input				write_en,

	output [63:0]	reg_data_1, reg_data_2
);

reg [63:0] registers [31:0];		// 32 64-bit general registers

// Combinational Logic for decoding register number into register data

assign reg_data_1 = registers[reg_num_1];
assign reg_data_2 = registers[reg_num_2];

// Sequential Logic for writing data into the target register

always @(posedge clk) begin		// this always can change when I learn more about always
	if (write_en)
		registers[write_reg] <= write_data;
end

endmodule
