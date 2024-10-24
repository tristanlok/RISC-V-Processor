interface rstN_interface;

	logic rstN; // active-low synchronous reset signal
	
	// modport for DUT
	modport dut_rstN(
		input rst_n // reset input to dut
	);
	
	// modport for testbench
	modport tester( //rst
		output rst_n // driven by rstN testbench agent
	);

endinterface