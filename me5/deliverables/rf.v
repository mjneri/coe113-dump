`timescale 1ns/1ps

module rf(
	input clk,
	input nrst,
	input [4:0] rd_addrA,
	input [4:0] rd_addrB,
	input [4:0] wr_addr,
	input wr_en,
	input [31:0] wr_data,
	output reg [31:0] rd_dataA,
	output reg [31:0] rd_dataB
);
	
	// declaring the registers
	reg [31:0] rf [31:0];

	integer i = 0;		// used in for loop
	// Write port
	always@(posedge clk or negedge nrst) begin
		if(!nrst)
			for(i = 0; i < 31; i=i+1)
				rf[i] <= 0;
		else
			if(wr_en)
				if(!wr_addr)
					rf[wr_addr] <= 31'd0;
				else
					rf[wr_addr] <= wr_data;
			else
				rf[wr_addr] <= rf[wr_addr];
	end

	// Read port
	always@(*) begin
		rd_dataA = rf[rd_addrA];
		rd_dataB = rf[rd_addrB];
	end
endmodule