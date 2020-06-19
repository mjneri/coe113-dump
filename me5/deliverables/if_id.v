`timescale 1ns/1ps

module if_id(
	input clk,
	input nrst,
	input [31:0] IF_pc4,
	input [31:0] pc_IF,
	input [31:0] IF_inst,
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
			ID_pc4 <= IF_pc4;
			pc_ID <= pc_IF;
		end
	end

	always@(negedge clk or negedge nrst)
		if(!nrst)
			ID_inst <= 0;
		else
			ID_inst <= IF_inst;
endmodule