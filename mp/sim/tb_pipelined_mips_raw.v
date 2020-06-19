`timescale 1ns/1ps
`define DEL_IN  7
`define MEM_ADDR_WIDTH 32
`define CLK_PERIOD  50
`define WORD_WIDTH 32

module tb_pipelined_mips_raw();
    
    reg clk;
    reg nrst;
    wire [`WORD_WIDTH - 1:0] inst;                  // 32-bit instruction (from instruction memory)
    wire [`WORD_WIDTH - 1:0] proc_data_in;          // data from memory to processor
    wire [`WORD_WIDTH - 1:0] proc_data_out;         // data from processor to memory
    wire data_wr;                                   // data memory write enable
    wire [`MEM_ADDR_WIDTH - 1:0] inst_addr;         // program counter
    wire [`MEM_ADDR_WIDTH - 1:0] data_addr;         // data memory address
    wire [31:0] pc_IF;
    wire [31:0] pc_ID;
    wire [31:0] pc_EXE;
    wire [31:0] pc_MEM;
    wire [31:0] pc_WB;

    // Debug signals
/*    wire [31:0] IDec_inst;
    wire flush_out;
    wire IDec_wr_en;
    wire IDec_data_wr;
    wire [31:0] WBack_data;
    wire [4:0] WBack_addr;*/

    pipelined_mips_raw UUT (
        .clk(clk),
        .nrst(nrst),
        .inst(inst),
        .data_in(proc_data_in),
        .inst_addr(inst_addr),
        .data_addr(data_addr),
        .data_out(proc_data_out),
        .data_wr(data_wr),
        .pc_IF(pc_IF),
        .pc_ID(pc_ID),
        .pc_EXE(pc_EXE),
        .pc_MEM(pc_MEM),
        .pc_WB(pc_WB)/*,
        // Debug signals
        .IDec_inst(IDec_inst),
        .flush_out(flush_out),
        .IDec_wr_en(IDec_wr_en),
        .IDec_data_wr(IDec_data_wr),
        .WBack_data(WBack_data),
        .WBack_addr(WBack_addr)*/
    );

    instmem I1 (
        .clk(clk),
        .inst_addr(inst_addr),
        .inst(inst)
    );

    datamem D1 (
        .clk(clk),
        .data_addr(data_addr),
        .data_wr(data_wr),
        .data_in(proc_data_in),
        .data_out(proc_data_out)
    );

    datamem_ans D2 ();

    always 
        #(`CLK_PERIOD / 2) clk = ~clk;

    integer i;
    integer done;
    integer check_done;
    integer pass;

    initial begin
		$vcdplusfile("tb_pipelined_mips_raw.vpd");
	    $vcdpluson;
		$sdf_annotate("../mapped/pipelined_mips_raw_mapped.sdf", UUT);    

        clk = 0;
        nrst = 0;
        done = 0;
        check_done = 0;
        #(`DEL_IN) nrst = 1;
    end

    always@(posedge clk) begin
        if(inst == 32'h0)
            check_done = check_done + 1;
    end
    always@(posedge clk) begin
        if(check_done == 10)
            done = 1;
    end


    always@(posedge done) begin
        pass = 0;
        $display("== SUMMARY ==");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=0;i<100;i=i+1) begin
            if(D1.memory[(i*4)]==D2.memory[(i*4)] && D1.memory[(i*4)+1]==D2.memory[(i*4)+1] && D1.memory[(i*4)+2]==D2.memory[(i*4)+2] && D1.memory[(i*4)+3]==D2.memory[(i*4)+3]) begin
                $display("%X%X%X%X\t%X%X%X%X\tPass",
                D1.memory[(i*4)],
                D1.memory[(i*4)+1],
                D1.memory[(i*4)+2],
                D1.memory[(i*4)+3],
                D2.memory[(i*4)],
                D2.memory[(i*4)+1],
                D2.memory[(i*4)+2],
                D2.memory[(i*4)+3]);
                pass = pass + 1;
            end else begin
                $display("%X%X%X%X\t%X%X%X%X\tFail",
                D1.memory[(i*4)],
                D1.memory[(i*4)+1],
                D1.memory[(i*4)+2],
                D1.memory[(i*4)+3],
                D2.memory[(i*4)],
                D2.memory[(i*4)+1],
                D2.memory[(i*4)+2],
                D2.memory[(i*4)+3]);
            end
        end

        $display("\n\n");
        $display("Passed\t%d/%d test cases", pass, i);//*/
        $finish;
    end
endmodule

module datamem_ans();
    reg [7:0] memory [0:2047];
    initial begin
        $readmemh("datamem_ans_parse.txt", memory);
    end
endmodule