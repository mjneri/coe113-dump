`timescale 1ns / 1ps

module pipelined_mips_raw(
	input clk,
	input nrst,
	input [31:0] inst,				// instruction from INSTMEM
	input [31:0] data_in,			// data from DATAMEM
	output reg [31:0] inst_addr,	// Program counter to INSTMEM
	output [31:0] data_addr,	// DATAMEM Address
	output [31:0] data_out,		// Data passed to DATAMEM
	output data_wr,				// mem_wr control signal
	output [31:0] pc_IF,
	output [31:0] pc_ID,
	output [31:0] pc_EXE,
	output [31:0] pc_MEM,
	output [31:0] pc_WB/*,
	// debug signals
	output [31:0] IDec_inst,
	output flush_out,
	output IDec_wr_en,
	output IDec_data_wr,
	output [31:0] WBack_data,
	output [4:0] WBack_addr*/
	);

// Supported instructions:
// ADD, SUB, SLT, SLL, SRL, JR -> R-type instructions
// ADDI, SLTI, LW, SW, BEQ, BNE -> I-type instructions
// J, JAL -> J-type instructions

/* Datapath signals */
	// IF Stage
	reg [31:0] pc_new;				// new PC
	wire [31:0] pc_4;				// PC + 4
	wire [31:0] j_addr;				// jump address
	wire [31:0] br_addr;			// branch address
	//
	assign pc_IF = inst_addr;
	assign pc_4 = inst_addr + 31'd4;

	// ID Stage
	wire [31:0] ID_pc4, ID_opA, ID_opB, ID_dataB, ID_imm32bit;
	wire [4:0] ID_wraddr;
	wire [31:0] ID_inst;
	//
	// Control signals for this stage
	wire sel_opA, sel_opB;
	wire [1:0] sel_dest;
	//
	// Control signals to next pipeline stages
	wire [5:0] ID_alu_op;
	wire ID_data_wr, ID_wr_en;
	wire [1:0] ID_sel_data;

	// EXE Stage
	wire [31:0] EXE_pc4, EXE_opA, EXE_opB, EXE_dataB, EXE_imm32bit;
	wire [4:0] EXE_wraddr;
	wire [31:0] EXE_inst, EXE_ALUres;
	//
	// Control signals for this stage
	wire [5:0] EXE_alu_op;
	//
	// Control signals to next pipeline stages
	wire EXE_data_wr, EXE_wr_en;
	wire [1:0] EXE_sel_data;

	// MEM Stage
	wire [31:0] MEM_pc4, MEM_ALUres, MEM_dataB;
	wire [4:0] MEM_wraddr;
	wire [31:0] MEM_inst, MEM_dataout;
	//
	// Control signals for this stage
	wire MEM_data_wr;
	//
	// Control signals for the last pipeline stage
	wire MEM_wr_en;
	wire [1:0] MEM_sel_data;

	// WB Stage
	wire [31:0] WB_pc4, WB_ALUres, WB_dataout;
	wire [4:0] WB_wraddr;
	wire [31:0] WB_inst;
	//
	// Control signals for this stage
	wire WB_wr_en;
	wire [1:0] WB_sel_data;

	// more datapath signals
	wire zf;						// zero flag
	wire [31:0] ID_dataA;			// RF read output
	wire [31:0] WB_wrdata;			// RF write data input
	wire [1:0] sel_pc;				// select PC
	wire flush;						// flush signal

	// Debug signals
	/*assign IDec_inst = ID_inst;
	assign flush_out = flush;
	assign IDec_wr_en = WB_wr_en;
	assign IDec_data_wr = MEM_data_wr;
	assign WBack_data = WB_wrdata;
	assign WBack_addr = WB_wraddr;*/

/* Pipeline Stages */
// IF Stage + sel_pc_blk
	sel_pc_blk sel_pc_blk1(clk, nrst, ID_inst, EXE_inst, zf, sel_pc, flush);
	always@(*) begin
		case(sel_pc)
			2'd1: pc_new <= j_addr;		// Jump address
			2'd2: pc_new <= br_addr;	// Branch address
			2'd3: pc_new <= ID_dataA;	// JR address
			default: pc_new <= pc_4;	// PC + 4
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
	// IF/ID Pipeline Reg
	if_id if_id1(clk, nrst, pc_4, pc_IF, inst, ID_pc4, pc_ID, ID_inst);

// ID Stage
	control control1(ID_inst, sel_opA, sel_opB, sel_dest,
						  ID_alu_op, ID_data_wr, ID_sel_data, ID_wr_en);

	wire [4:0] rs, rt, rd, shamt;
	assign rs = ID_inst[25:21];
	assign rt = ID_inst[20:16];
	assign rd = ID_inst[15:11];
	assign shamt = ID_inst[10:6];

	rf rf1(clk, nrst, rs, rt, WB_wraddr, WB_wr_en,
			 WB_wrdata, ID_dataA, ID_dataB);

	assign j_addr = {ID_pc4[31:28], ID_inst[25:0], 2'b00};
	assign ID_imm32bit = { {16{ID_inst[15]}}, ID_inst[15:0] };
	assign ID_opA = !sel_opA? ID_dataA : shamt;
	assign ID_opB = !sel_opB? ID_dataB : ID_imm32bit;
	assign ID_wraddr = (sel_dest == 2'd1)? rd : ( (sel_dest == 2'd2)? 5'd31 : rt );

	id_exe id_exe1(clk, nrst, flush, ID_pc4, ID_opA, ID_opB,
						ID_dataB, ID_imm32bit, ID_wraddr, pc_ID, ID_inst,
						EXE_pc4, EXE_opA, EXE_opB, EXE_dataB, EXE_imm32bit,
						EXE_wraddr, pc_EXE, EXE_inst,
						ID_alu_op, ID_data_wr, ID_wr_en, ID_sel_data,
						EXE_alu_op, EXE_data_wr, EXE_wr_en, EXE_sel_data);

// EXE Stage
	// ALU Unit
	// Adder for branch address
	alu alu1(EXE_opA, EXE_opB, EXE_alu_op, zf, EXE_ALUres);
	assign br_addr = EXE_pc4 + (EXE_imm32bit << 2);

	exe_mem exe_mem1(clk, nrst, EXE_pc4, EXE_ALUres,
						  EXE_dataB, EXE_wraddr, pc_EXE, EXE_inst,
						  MEM_pc4, MEM_ALUres, MEM_dataB, MEM_wraddr, pc_MEM, MEM_inst,
						  EXE_data_wr, EXE_wr_en, EXE_sel_data,
						  MEM_data_wr, MEM_wr_en, MEM_sel_data);

// MEM Stage
	// Data Memory
	assign data_addr = MEM_ALUres;	// Data addr passed to DATAMEM
	assign data_out = MEM_dataB;		// Data passed to DATAMEM
	assign data_wr = MEM_data_wr;		// Control signal
	assign MEM_dataout = data_in;		// Data from DATAMEM

	mem_wb mem_wb1(clk, nrst, MEM_pc4, MEM_ALUres,
						MEM_dataout, MEM_wraddr, pc_MEM, MEM_inst,
						WB_pc4, WB_ALUres, WB_dataout, WB_wraddr, pc_WB, WB_inst,
						MEM_wr_en, MEM_sel_data,
						WB_wr_en, WB_sel_data);

// WB Stage
	// mux sel data
	assign WB_wrdata = (WB_sel_data == 2'd1)? WB_dataout : ( (WB_sel_data == 2'd2)? WB_pc4 : WB_ALUres );

endmodule