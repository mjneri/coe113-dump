`timescale 1ns / 1ps

module single_cycle_mips(
	input clk,
	input nrst,
	input [31:0] inst,				// instruction from INSTMEM
	input [31:0] data_in,			// data from DATAMEM
	output reg [31:0] inst_addr,	// Program counter to INSTMEM
	output [31:0] data_addr,	// DATAMEM Address
	output [31:0] data_out,		// Data passed to DATAMEM
	output data_wr				// mem_wr control signal
	);
// Supported instructions:
// ADD, SUB, SLT, SLL, SRL, JR -> R-type instructions
// ADDI, SLTI, LW, SW, BEQ, BNE -> I-type instructions
// J, JAL -> J-type instructions

// Assign wires for the instruction's parts
	wire [5:0] opcode, func;
	wire [4:0] rs, rt, rd, shamt;
	assign opcode = inst[31:26];
	assign rs = inst[25:21];
	assign rt = inst[20:16];
	assign rd = inst[15:11];
	assign shamt = inst[10:6];
	assign func = inst[5:0];

// Datapath signals
	reg [31:0] pc_new;				// new PC
	wire [31:0] pc_4;				// PC + 4
	wire [31:0] j_addr;				// jump address
	wire [31:0] br_addr;			// branch address
	wire [31:0] imm_32bit;			// 32bit sign extended immediate

	assign imm_32bit = { {16{inst[15]}}, inst[15:0] };
	assign pc_4 = inst_addr + 31'd4;
	assign j_addr = {pc_4[31:28], inst[25:0], 2'b00};
	assign br_addr = pc_4 + (imm_32bit << 2);

// Control signals
	wire [1:0] sel_dest, sel_data, sel_pc;
	wire sel_opA, sel_opB, wr_en;
	wire [5:0] alu_op;	

// more datapath signals
	wire [31:0] ALU_out;			// ALU output
	wire [31:0] op_A;				// mux selected opA
	wire [31:0] op_B;				// mux selected opB
	wire zf;						// zero flag
	wire [31:0] rd_dataA, rd_dataB;	// RF read output
	wire [4:0] wr_addr;				// RF write addr input
	wire [31:0] wr_data;			// RF write data input

	control control1(opcode, func, zf, sel_dest, sel_data, sel_pc, 
					sel_opA, sel_opB, wr_en, data_wr, alu_op);

	assign wr_addr = (sel_dest == 2'd1)? rd : ( (sel_dest == 2'd2)? 5'd31 : rt );
	assign wr_data = (sel_data == 2'd1)? data_in : ( (sel_data == 2'd2)? pc_4 : ALU_out );

	
	rf rf1(clk, nrst, rs, rt, wr_addr, wr_en, wr_data, rd_dataA, rd_dataB);
	assign data_out = rd_dataB;

	assign op_A = !sel_opA? rd_dataA : shamt;
	assign op_B = !sel_opB? rd_dataB : imm_32bit;

	alu alu1(op_A, op_B, alu_op, zf, ALU_out);
	assign data_addr = ALU_out;

	
// PC =============================================================================================================================================
// mux connected to PC
// sel_pc:
// 0 - PC + 4
// 1 - Jump address
// 2 - Branch address
// 3 - JR address
	always@(*) begin
		case(sel_pc)
			2'd1: pc_new <= j_addr;
			2'd2: pc_new <= br_addr;
			2'd3: pc_new <= rd_dataA;
			default: pc_new <= pc_4;
		endcase
	end
// PC
	always@(posedge clk or negedge nrst) begin
		if(!nrst)
			inst_addr <= 0;
		else begin
			inst_addr <= pc_new;
		end
	end
endmodule