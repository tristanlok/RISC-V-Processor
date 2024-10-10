module ALU_func_verify;
   
typedef enum logic [2:0] {
   ADD_OP = 3'b000,
   AND_OP = 3'b001,
   OR_OP = 3'b011,
   SUB_OP = 3'b111
} op_type;

logic [63:0] operand1_in;
logic [63:0] operand2_in;
logic [2:0] aluOpcode_in;
logic [63:0] result_out;
logic zeroFlag_out;
op_type op_set;

assign aluOpcode_in = op_set;

ALU DUT (.operand1_in, .operand2_in, .aluOpcode_in, .result_out, .zeroFlag_out);

covergroup op_coverage;

   coverpoint op_set {
      bins single_ops[] = {[ADD_OP : SUB_OP]};
      bins two_ops[] = ([ADD_OP : SUB_OP] [* 2]);
   }

endgroup

covergroup zero_or_ones_on_ops;
   
   all_ops: coverpoint op_set {
      bins single_ops[] {[ADD_OP : SUB_OP]};
      bins two_ops[] ([ADD_OP : SUB_OP] [* 2]);
   }
   
   operand1_cover : coverpoint operand1_in {
      bins zeroes = {64'b0};
      bins others = {[64'h1: 64'hFFFFFFFFFFFFFFFE]};
      bins ones = {64'hFFFFFFFFFFFFFFFF};
   }
   
   operand2_cover : coverpoint operand2_in {
      bins zeroes = {64'b0};
      bins others = {[64'h1: 64'hFFFFFFFFFFFFFFFE]};
      bins ones = {64'hFFFFFFFFFFFFFFFF};
   }

   zero_to_one : cross operand1_cover, operand2_cover, all_ops {
      bins all_ops_00 = binsof (all_ops) intersect {[ADD_OP:SUB_OP]} && (binsof (operand1_cover.zeroes) || binsof (operand2_cover.zeroes));
      bins all_ops_FF = binsof (all_ops) intersect {[ADD_OP:SUB_OP]} && (binsof (operand1_cover.ones) || binsof (operand2_cover.ones));
   }

endgroup

op_coverage oc;
zero_or_ones_on_ops;

initial begin : coverage
   
   oc = new();
   zero_or_one = new();
	
	forever begin
		oc.sample();
		zero_or_one.sample();
	end
end : coverage

function op_type get_op();
	op_type op_choice;
	op_choice = $random;
	return op_choice;
endfunction

// write get data function

endmodule
   	