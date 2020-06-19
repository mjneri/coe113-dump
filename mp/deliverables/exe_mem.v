`timescale 1ns/1ps

module exe_mem(
	input clk,
	input nrst,
	// inputs
	input [31:0] EXE_pc4,
	input [31:0] EXE_ALUres,
	input [31:0] EXE_dataB,
	input [4:0] EXE_wraddr,
	input [31:0] pc_EXE,
	input [31:0] EXE_inst,
	// outputs
	output reg [31:0] MEM_pc4,
	output reg [31:0] MEM_ALUres,
	output reg [31:0] MEM_dataB,
	output reg [4:0] MEM_wraddr,
	output reg [31:0] pc_MEM,
	output reg [31:0] MEM_inst,
	// NOTE: add control signals here
	input EXE_data_wr,
	input EXE_wr_en,
	input [1:0] EXE_sel_data,
	
	output reg MEM_data_wr,
	output reg MEM_wr_en,
	output reg [1:0] MEM_sel_data
);
	
	always@(posedge clk or negedge nrst) begin
		if(!nrst) begin
			MEM_pc4 <= 0;
			MEM_ALUres <= 0;
			MEM_dataB <= 0;
			MEM_wraddr <= 0;
			pc_MEM <= 0;
			MEM_inst <= 0;

			MEM_data_wr <= 0;
			MEM_wr_en <= 0;
			MEM_sel_data <= 0;
		end
		else begin
			MEM_pc4 <= EXE_pc4;
			MEM_ALUres <= EXE_ALUres;
			MEM_dataB <= EXE_dataB;
			MEM_wraddr <= EXE_wraddr;
			pc_MEM <= pc_EXE;
			MEM_inst <= EXE_inst;

			MEM_data_wr <= EXE_data_wr;
			MEM_wr_en <= EXE_wr_en;
			MEM_sel_data <= EXE_sel_data;
		end
	end
endmodule