package temp;
	typedef enum logic [1:0] {
		OP_ADD = 2'b00,
		OP_SUB = 2'b01,
		OP_AND = 2'b10,
		OP_OR	 = 2'b11
	} Alu_Operation_t;

	typedef enum logic {
		REG_MUX,
		IMM_MUX
	} reg_alu_ctrl_t;

	typedef enum logic {
		DATA_MEM_MUX,
		DATA_ALU_MUX
	} data_reg_ctrl_t;
endpackage
