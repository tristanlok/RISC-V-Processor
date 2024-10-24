interface instrMem_interface;

	logic [31:0] instruction; // 32-bit instruction
	
	// modport for DUT
	modport dut_instr(
		input currInstr // instruction sent to DUT for execution
	);
	
	// modport for testbench 
	modport tester(
		output currInstr // instruction recieved from instrMemory agent
	);

endinterface