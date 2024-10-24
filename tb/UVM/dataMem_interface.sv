interface dataMem_interface #(
	parameter DATA_WIDTH_POW = 6,
	parameter ADDR_WIDTH_POW = 6
);

	logic [ADDR_WIDTH-1:0] addr;
	logic [ADDR_WIDTH-1:0] data_in;
	logic [ADDR_WIDTH-1:0] data_out;
	logic readEnable;
	logic writeEnable;
	
	// modport for dut
	modport dut_dataMem(
		inout addr, // memory address used for writing and reading
		output data_in, writeEnable // getting DUT's data to be written and write enable signal
		input data_out, readEnable // giving DUT data to be read and read enable signal
	);
	
	// modport for driver
	modport driver(
		in
	
	