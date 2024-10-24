module uvm_top;

	import riscV_pkg::*;
	
	// Instantiates the DUT clock
	logic clk_in = '0;
	
	// Flip the clock every 10 ns
	always #10 clk_in <= ~clk_in;
	
	