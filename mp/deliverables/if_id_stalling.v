`timescale 1ns/1ps

module if_id_stalling(
	input clk,
	input nrst,
	input stall,
	input [31:0] IF_pc4,
	input [31:0] pc_IF,		// address of the instruction
	input [31:0] IF_inst,	// actual instruction
	output reg [31:0] ID_pc4,
	output reg [31:0] pc_ID,
	output reg [31:0] ID_inst
);
	always@(posedge clk or negedge nrst) begin
		if(!nrst) begin
			ID_pc4 <= 0;
			pc_ID <= 0;
		end
		else begin
			if(stall) begin
				ID_pc4 <= ID_pc4;
				pc_ID <= pc_ID;
			end
			else begin
				ID_pc4 <= IF_pc4;
				pc_ID <= pc_IF;
			end
		end
	end

	always@(negedge clk or negedge nrst) begin
		if(!nrst)
			ID_inst <= 0;
		else begin
			if(stall)
				ID_inst <= ID_inst;
			else
				ID_inst <= IF_inst;
		end
	end
	
endmodule