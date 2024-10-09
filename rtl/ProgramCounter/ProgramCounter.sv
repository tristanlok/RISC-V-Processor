module ProgramCounter (
   input logic    [63:0] instruction_i,
   input logic           clock,
   input logic           reset,
   
   output logic   [63:0] instruction_o
);

always_ff @(posedge clock) begin
   if (reset) begin
      instruction_o <= '0;
   end else begin
      instruction_o <= instruction_i;
   end
end

endmodule
