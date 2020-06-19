`timescale 1ns/1ps

module sel_pc_blk(
	input clk,
	input nrst,
	input [31:0] ID_inst,
	input [31:0] EXE_inst,
	input zf,
	output reg [1:0] sel_pc,
	output reg flush
);
	wire [5:0] ID_opcode, ID_func, EXE_opcode, EXE_func;
	assign ID_opcode = ID_inst[31:26];
	assign ID_func = ID_inst[5:0];
	assign EXE_opcode = EXE_inst[31:26];
	assign EXE_func = EXE_inst[5:0];
	parameter JR = 6'h08;	// func

	parameter BEQ = 6'h04;	// opcode
	parameter BNE = 6'h05;	// opcode
	parameter JUMP = 6'h02;	// opcode
	parameter JAL = 6'h03;	// opcode

	// FSM states
	parameter INIT = 3'b000;
	parameter BR1 = 3'b001;
	parameter BR2 = 3'b011;
	parameter J1 = 3'b100;
	parameter J2 = 3'b110;

	reg [2:0] cstate, nstate;

	always@(*) begin
		// sel_pc [uses zf from ALU]
		// 0 - PC + 4
		// 1 - Jump address
		// 2 - Branch address
		// 3 - JR address
		if(EXE_opcode == BEQ || EXE_opcode == BNE)
			if((EXE_opcode == BEQ && zf == 1) || (EXE_opcode == BNE && zf == 0)) begin
				sel_pc = 2'd2;
			end
			else begin
				sel_pc = 2'd0;
			end
		else begin
			if(ID_opcode == 6'h0 && ID_func == JR)
				sel_pc = 2'd3;
			else if(ID_opcode == JUMP || ID_opcode == JAL)
				sel_pc = 2'd1;
			else
				sel_pc = 2'd0;
		end
	end

	// Flush finite state machine
	always@(posedge clk or negedge nrst) begin
		if(!nrst) begin
			cstate = 0;
		end
		else begin
			// Check for Jumps by checking if sel_pc == 1/3 -> delay flush by 1 clock cycle
			// OR check if the branch was taken by checking if sel_pc == 2
			cstate = nstate;
			case(cstate)
				BR1: flush = 1;
				BR2: flush = 1;
				J1: flush = 0;
				J2: flush = 1;
				default: flush = 0;
			endcase
		end
	end

	always@(*) begin
		case(cstate)
			INIT:
				if(sel_pc == 2'd2)
					nstate = BR1;
				else if(sel_pc == 2'd1 || sel_pc == 2'd3)
					nstate = J1;
				else
					nstate = INIT;
			BR1: nstate = BR2;
			J1: nstate = J2;
			default: nstate = INIT;
		endcase
	end
endmodule