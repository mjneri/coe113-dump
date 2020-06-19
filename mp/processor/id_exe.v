`timescale 1ns/1ps

module id_exe(
	input clk,
	input nrst,
	input flush,
	// inputs
	input [31:0] ID_pc4,
	input [31:0] ID_opA,
	input [31:0] ID_opB,
	input [31:0] ID_dataB,
	input [31:0] ID_imm32bit,
	input [4:0] ID_wraddr,
	input [31:0] pc_ID,
	input [31:0] ID_inst,
	// outputs
	output reg [31:0] EXE_pc4,
	output reg [31:0] EXE_opA,
	output reg [31:0] EXE_opB,
	output reg [31:0] EXE_dataB,
	output reg [31:0] EXE_imm32bit,
	output reg [4:0] EXE_wraddr,
	output reg [31:0] pc_EXE,
	output reg [31:0] EXE_inst,
	// NOTE: add control signals here
	input [5:0] ID_alu_op,
	input ID_data_wr,
	input ID_wr_en,
	input [1:0] ID_sel_data,

	output reg [5:0] EXE_alu_op,
	output reg EXE_data_wr,
	output reg EXE_wr_en,
	output reg [1:0] EXE_sel_data
);
	
	always@(posedge clk or negedge nrst) begin
		if(!nrst) begin
			EXE_pc4 <= 0;
			EXE_opA <= 0;
			EXE_opB <= 0;
			EXE_dataB <= 0;
			EXE_imm32bit <= 0;
			EXE_wraddr <= 0;
			pc_EXE <= 0;
			EXE_inst <= 0;
		end
		else begin
			EXE_pc4 <= ID_pc4;
			EXE_opA <= ID_opA;
			EXE_opB <= ID_opB;
			EXE_dataB <= ID_dataB;
			EXE_imm32bit <= ID_imm32bit;
			EXE_wraddr <= ID_wraddr;
			pc_EXE <= pc_ID;
			EXE_inst <= ID_inst;
		end
	end

	always@(posedge clk or negedge nrst) begin
		if(!nrst) begin
			EXE_alu_op <= 0;
			EXE_data_wr <= 0;
			EXE_wr_en <= 0;
			EXE_sel_data <= 0;
		end
		else begin
			if(flush) begin
				EXE_alu_op <= 0;
				EXE_data_wr <= 0;
				EXE_wr_en <= 0;
				EXE_sel_data <= 0;
			end
			else begin
				EXE_alu_op <= ID_alu_op;
				EXE_data_wr <= ID_data_wr;
				EXE_wr_en <= ID_wr_en;
				EXE_sel_data <= ID_sel_data;
			end
		end
	end
endmodule