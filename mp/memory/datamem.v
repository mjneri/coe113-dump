`timescale 1ns/1ps

`define MEM_DEPTH  1024
`define MEM_WIDTH  8
`define WORD_WIDTH 32

module datamem(
  clk,
  data_addr,
  data_wr,
  data_in, // input to processor
  data_out // output of processor
  );

  input clk, data_wr;
  input [`WORD_WIDTH-1:0] data_addr,data_out;
  output [`WORD_WIDTH-1:0] data_in;

  reg [`MEM_WIDTH-1:0] memory [0:`MEM_DEPTH-1];

  initial begin
    $readmemh("datamem_parse.txt",memory);
  end

  // Read data port
  reg [`WORD_WIDTH-1:0] data_in_temp;

  always@(posedge clk)
    data_in_temp <= {memory[data_addr],
                memory[data_addr+1],
                memory[data_addr+2],
                memory[data_addr+3]};

  assign #(`INPUT_DELAY) data_in = data_in_temp;

  // Write data port
  always@(posedge clk)
    if (data_wr) begin
      memory[data_addr] <= data_out[31:24];
      memory[data_addr+1] <= data_out[23:16];
      memory[data_addr+2] <= data_out[15:8];
      memory[data_addr+3] <= data_out[7:0];
    end
    
endmodule