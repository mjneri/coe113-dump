`timescale 1ns/1ps

`define MEM_DEPTH  1024
`define MEM_WIDTH  8
`define WORD_WIDTH 32

module instmem(
  clk,
  inst_addr,
  inst
  );

  input clk;
  input [`WORD_WIDTH-1:0] inst_addr;
  output [`WORD_WIDTH-1:0] inst;

  reg [`MEM_WIDTH-1:0] memory [0:`MEM_DEPTH-1];

  initial begin
    $readmemh("instmem_parse.txt", memory);
  end

  // Read data port
  reg [`WORD_WIDTH-1:0] inst_temp;

  always@(posedge clk)
    inst_temp <= {memory[inst_addr],
             memory[inst_addr+1],
             memory[inst_addr+2],
             memory[inst_addr+3]};

  assign #(`INPUT_DELAY) inst = inst_temp;

endmodule