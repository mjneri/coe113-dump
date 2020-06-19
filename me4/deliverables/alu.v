`timescale 1ns/1ps

module alu(
	input [31:0] opA,
	input [31:0] opB,
	input [5:0] alu_op,
	output reg zf,
	output reg [31:0] ALU_out
);

// Parameters for func/opcode
	parameter ADD = 6'h20;
	parameter SUB = 6'h22;
	parameter SLT = 6'h2a;
	parameter SLL = 6'h00;
	parameter SRL = 6'h02;

// ALU ops:
// 0x20: Add
// 0x22: Sub
// 0x2A: set less than
// 0x00: Shift left
// 0x02: Shift right
	always@(*) begin
		case(alu_op)
			ADD: ALU_out = opA + opB;
			SUB: ALU_out = opA - opB;
			SLT: begin
					if( ((opA[31])^(opB[31])) == 1'b1 )
						if(opA[31] == 1'b0)
							ALU_out = 32'd0;
						else
							ALU_out = 32'd1;
					else
						ALU_out = (opA < opB)? 32'd1 : 32'd0;
				end
			SLL: ALU_out = opB << opA;
			SRL: ALU_out = opB >> opA;
			default: ALU_out = opA + opB;
		endcase
		zf = ~|ALU_out;
	end

endmodule