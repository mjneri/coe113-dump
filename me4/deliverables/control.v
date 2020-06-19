module control(
	input [5:0] opcode,
	input [5:0] func,
	input zf,
	output reg [1:0] sel_dest,
	output reg [1:0] sel_data,
	output reg [1:0] sel_pc,
	output reg sel_opA,
	output reg sel_opB,
	output reg wr_en,
	output reg data_wr,
	output reg [5:0] alu_op
	);

// Parameters for func/opcode
	parameter ADD = 6'h20;	// func
	parameter SUB = 6'h22;	// func
	parameter SLT = 6'h2a;	// func
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
	always@(*) begin
		// sel_dest<1:0>
		// 0 - I-type inst
		// 1 - R-type inst
		// 2 - $ra
		if(opcode == 6'b0)		// R-Type
			sel_dest = 2'd1;
		else if(opcode == JAL)
			sel_dest = 2'd2;		// JAL
		else
			sel_dest = 2'd0;
	end

	always@(*) begin
		// sel_data
		// 0 - R-type + some I-type instructions
		// 1 - LW/SW
		// 2 - save PC+4 (JAL)
		if(opcode == JAL)
			sel_data = 2'd2;
		else if(opcode == LW || opcode == SW)
			sel_data = 2'd1;
		else
			sel_data = 2'd0;
	end

	always@(*) begin
		// sel_pc [uses zf from ALU]
		// 0 - PC + 4
		// 1 - Jump address
		// 2 - Branch address
		// 3 - JR address
		if(opcode == 6'h0 && func == JR)
			sel_pc = 2'd3;
		else if((opcode == BEQ && zf == 1) || (opcode == BNE && zf == 0))
			sel_pc = 2'd2;
		else if(opcode == JUMP || opcode == JAL)
			sel_pc = 2'd1;
		else
			sel_pc = 2'd0;
	end

	always@(*) begin
		// sel_opA
		// 0 - Everything else
		// 1 - SLL/ SRL
		if(opcode == 6'h0 && (func == SLL || func == SRL))
			sel_opA = 2'd1;
		else
			sel_opA = 2'd0;
	end

	always@(*) begin
		// sel_opB
		// 0 - R-type, BEQ, BNE
		// 1 - I-type
		if(opcode == 6'h0 || opcode == BEQ || opcode == BNE)
			sel_opB = 2'd0;
		else
			sel_opB = 2'd1;
	end

	always@(*) begin
		// wr_en
		// 0 - SW, BEQ, BNE, JR, Jump
		// 1 - LW, R-type, I-type, JAL
		case(opcode)
			6'h0: if(func == JR)
					wr_en = 1'd0;
				  else
				  	wr_en = 1'd1;
			SW: wr_en = 1'd0;
			BEQ: wr_en = 1'd0;
			BNE: wr_en = 1'd0;
			JUMP: wr_en = 1'd0;
			default: wr_en = 1'd1;
		endcase
	end

	always@(*) begin
		// alu_op
		case(opcode)
			6'h0:	// Rtype
				case(func)
					ADD: alu_op = ADD;
					SUB: alu_op = SUB;
					SLT: alu_op = SLT;
					SLL: alu_op = SLL;
					SRL: alu_op = SRL;
					default: alu_op = ADD;
				endcase
			ADDI: alu_op = ADD;
			SLTI: alu_op = SLT;
			BEQ:  alu_op = SUB;
			BNE:  alu_op = SUB;
			default: alu_op = ADD;
		endcase
	end
	
	always@(*) begin
		// data_wr
		// 0 - Everything else
		// 1 - SW
		if(opcode == SW)
			data_wr = 1;
		else
			data_wr = 0;
	end

endmodule