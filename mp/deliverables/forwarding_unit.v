`timescale 1ns/1ps

module forwarding_unit(
	input [31:0] ID_inst,

	input [4:0] EXE_wraddr,
	input EXE_wr_en,

	input [4:0] MEM_wraddr,
	input MEM_wr_en,

	input [4:0] WB_wraddr,
	input WB_wr_en,

	output reg [1:0] forwardA,
	output reg [1:0] forwardB
);
	// Parameters for func & opcode
	parameter SLL = 6'h00;	// func
	parameter SRL = 6'h02;	// func
	parameter JR = 6'h08;	// func

	parameter ADDI = 6'h08;	// opcode
	parameter SLTI = 6'h0a;	// opcode
	parameter LW = 6'h23;	// opcode
	parameter SW = 6'h2b;	// opcode
	parameter BEQ = 6'h04;	// opcode
	parameter BNE = 6'h05;	// opcode

	parameter JUMP = 6'h02;	// opcode
	parameter JAL = 6'h03;	// opcode

	wire [4:0] ID_readA, ID_readB;				// Registers being read from
	wire [4:0] EXE_write, MEM_write, WB_write;	// Registers being written to
	
	wire [5:0] ID_opcode, ID_func;
	wire [4:0] ID_rs, ID_rt;

	wire Rtype1, Rtype2, Itype1, Itype2, JtypeJR, Jtype;	// determine the inst type
															// Rtype1: ADD, SUB, SLT
															// Rtype2: SLL, SRL
															// Itype1: ADDI, SLTI, LW
															// Itype2: SW, BEQ, BNE
															// JtypeJR: JR
															// Jtype: J, JAL
	assign Rtype2 = (ID_opcode == 6'd0)? (((ID_func == SRL)||(ID_func == SLL))? 1: 0 ) : 0;
	assign Rtype1 = ~Rtype2;
	assign Jtype = (ID_opcode == JUMP)||(ID_opcode == JAL)? 1 : 0;
	assign Itype1 = ((ID_opcode == ADDI)||(ID_opcode == SLTI)||(ID_opcode == LW))? 1 : 0;
	assign Itype2 = ((ID_opcode == SW)||(ID_opcode == BEQ)||(ID_opcode == BNE))? 1 : 0;
	assign JtypeJR = (ID_opcode == 6'h0)? ((ID_func == JR)? 1: 0) : 0;

	assign ID_opcode = ID_inst[31:26];
	assign ID_func = ID_inst[5:0];
	assign ID_rs = ID_inst[25:21];
	assign ID_rt = ID_inst[20:16];

	// Assign read registers & write registers
	assign ID_readA = Rtype2? 5'h0 : (Jtype? 5'h0 : ID_rs );
	assign ID_readB = Itype2? ID_rt : ((Itype1 || JtypeJR)? 5'h0 : (Jtype? 5'h0:  ID_rt));
	
	assign EXE_write = EXE_wr_en? EXE_wraddr : 6'h0;
	assign MEM_write = MEM_wr_en? MEM_wraddr : 6'h0;
	assign WB_write = WB_wr_en? WB_wraddr : 6'h0;

	// forwardA
	always@(*) begin
		if(ID_readA == 0)
			forwardA = 0;
		else begin
			if(ID_readA == EXE_write)
				forwardA = 2'd1;
			else begin
				if(ID_readA == MEM_write)
					forwardA = 2'd2;
				else begin
					if(ID_readA == WB_write)
						forwardA = 2'd3;
					else
						forwardA = 2'd0;
				end
			end
		end
	end

	// forwardB
	always@(*) begin
		if(ID_readB == 0)
			forwardB = 0;
		else begin
			if(ID_readB == EXE_write)
				forwardB = 2'd1;
			else begin
				if(ID_readB == MEM_write)
					forwardB = 2'd2;
				else begin
					if(ID_readB == WB_write)
						forwardB = 2'd3;
					else
						forwardB = 2'd0;
				end
			end
		end
	end
	
endmodule