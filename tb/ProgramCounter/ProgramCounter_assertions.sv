module ProgramCounter_assertions(
   input logic    [63:0] instruction_i,
   input logic           clock,
   
   output logic   [63:0] instruction_o
);

ProgramCounter DUT (.instruction_i, .clock, .instruction_o);

always_ff @(posedge clock) begin

	assert (instruction_o >= 0);
	
	assert (instruction_o == $past(instruction_i));
	
end

endmodule