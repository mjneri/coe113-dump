`timescale 1ns/1ps

module mem_wb(
	input clk,
	input nrst,
	// inputs
	input [31:0] MEM_pc4,
	input [31:0] MEM_ALUres,
	input [31:0] MEM_dataout,
	input [4:0] MEM_wraddr,
	input [31:0] pc_MEM,
	input [31:0] MEM_inst,
	// outputs
	output reg [31:0] WB_pc4,
	output reg [31:0] WB_ALUres,
	output reg [31:0] WB_dataout,
	output reg [4:0] WB_wraddr,
	output reg [31:0] pc_WB,
	output reg [31:0] WB_inst,
	// NOTE: add control signals here
	input MEM_wr_en,
	input [1:0] MEM_sel_data,
	
	output reg WB_wr_en,
	output reg [1:0] WB_sel_data
);
	
	always@(posedge clk or negedge nrst) begin
		if(!nrst) begin
			WB_pc4 <= 0;
			WB_ALUres <= 0;
			WB_wraddr <= 0;
			pc_WB <= 0;
			WB_inst <= 0;

			WB_wr_en <= 0;
			WB_sel_data <= 0;
		end
		else begin
			WB_pc4 <= MEM_pc4;
			WB_ALUres <= MEM_ALUres;
			WB_wraddr <= MEM_wraddr;
			pc_WB <= pc_MEM;
			WB_inst <= MEM_inst;

			WB_wr_en <= MEM_wr_en;
			WB_sel_data <= MEM_sel_data;
		end
	end

	always@(negedge clk or negedge nrst) begin
		if(!nrst) 
			WB_dataout <= 0;
		else
			WB_dataout <= MEM_dataout;
	end
endmodule