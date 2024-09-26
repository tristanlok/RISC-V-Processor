module program_counter (
   input logic    [63:0] instruction_i,
   input logic           clock,
   
   output logic   [63:0] instruction_o
);

always_ff @(posedge clock) begin
   instruction_o <= instruction_i;
end

endmodule
