`timescale 1ns/1ps
`define DEL_IN  7
`define MEM_ADDR_WIDTH 32
`define CLK_PERIOD  50
`define WORD_WIDTH 32

module tb_single_cycle_mips();
    
    reg clk;
    reg nrst;
    wire [`WORD_WIDTH - 1:0] inst;                  // 32-bit instruction (from instruction memory)
    wire [`WORD_WIDTH - 1:0] proc_data_in;          // data from memory to processor
    wire [`WORD_WIDTH - 1:0] proc_data_out;         // data from processor to memory
    wire data_wr;                                   // data memory write enable
    wire [`MEM_ADDR_WIDTH - 1:0] inst_addr;         // program counter
    wire [`MEM_ADDR_WIDTH - 1:0] data_addr;         // data memory address

    single_cycle_mips UUT (.clk(clk),
        .nrst(nrst),
        .inst(inst),
        .data_in(proc_data_in),
        .data_out(proc_data_out),
        .data_wr(data_wr),
        .inst_addr(inst_addr),
        .data_addr(data_addr)
    );

    instmem I1 (.inst_addr(inst_addr),
        .inst(inst)
    );

    datamem D1 (.clk(clk),
        .data_addr(data_addr),
        .data_wr(data_wr),
        .data_in(proc_data_out),
        .data_out(proc_data_in)
    );

    datamem_ans D2 ();

    always 
        #(`CLK_PERIOD / 2) clk = ~clk;

    integer i;
    integer done;
    integer lwswpass, addpass, subpass, sltpass, addipass, sltipass, beqpass, bnepass;

    initial begin
		$vcdplusfile("tb_single_cycle_mips.vpd");
	    $vcdpluson;
		$sdf_annotate("../mapped/single_cycle_mips_mapped.sdf", UUT);    

        clk = 0;
        nrst = 0;
        done = 0;
        #(`DEL_IN) nrst = 1;
    end

     always@(posedge clk) begin
        if(inst == 32'h0)
            done = 1;
    end

    always@(posedge done) begin
        lwswpass = 0;
        addpass = 0;
        subpass = 0; 
        sltpass = 0;
        addipass = 0;
        sltipass = 0;
        beqpass = 0;
        bnepass = 0;

        // lw sw
        $display("===== LW/SW =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=0;i<6;i=i+1) begin
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
                lwswpass = lwswpass + 1;
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
        // add
        $display("\n===== ADD =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=6;i<18;i=i+1) begin
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
                addpass = addpass + 1;
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
        // sub
        $display("\n===== SUB =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=18;i<30;i=i+1) begin
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
                subpass = subpass + 1;
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
        // slt
        $display("\n===== SLT =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=30;i<42;i=i+1) begin
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
                sltpass = sltpass + 1;
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
        // addi
        $display("\n===== ADDI =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=42;i<54;i=i+1) begin
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
                addipass = addipass + 1;
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
        // slti
        $display("\n===== SLTI =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=54;i<66;i=i+1) begin
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
                sltipass = sltipass + 1;
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
        // beq
        $display("\n===== BEQ =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=66;i<78;i=i+1) begin
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
                beqpass = beqpass + 1;
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
        // bne
        $display("\n===== BNE =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=78;i<90;i=i+1) begin
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
                bnepass = bnepass + 1;
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
        // additional cases for ADD
        $display("\n===== ADD+ =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=90;i<95;i=i+1) begin
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
                addpass = addpass + 1;
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
        // additional cases for ADDI
        $display("\n===== ADDI+ =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=95;i<100;i=i+1) begin
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
                addipass = addipass + 1;
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
        // additional cases for SUB
        $display("\n===== SUB+ =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=100;i<105;i=i+1) begin
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
                subpass = subpass + 1;
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
        // additional cases for SLT
        $display("\n===== SLT+ =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=105;i<109;i=i+1) begin
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
                sltpass = sltpass + 1;
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
        // additional cases for SLTI
        $display("\n===== SLTI+ =====");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=109;i<113;i=i+1) begin
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
                sltipass = sltipass + 1;
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
        $display("LW/SW Passed\t%d/6 test cases", lwswpass);
        $display("ADD Passed\t%d/17 test cases", addpass);
        $display("SUB Passed\t%d/17 test cases", subpass);
        $display("SLT Passed\t%d/16 test cases", sltpass);
        $display("ADDI Passed\t%d/17 test cases", addipass);
        $display("SLTI Passed\t%d/16 test cases", sltipass);
        $display("BEQ Passed\t%d/12 test cases", beqpass);
        $display("BNE Passed\t%d/12 test cases\n", bnepass);
        $finish;
    end
endmodule

module datamem_ans();
    reg [7:0] memory [0:2047];
    initial begin
        $readmemh("datamem_ans_parse.txt", memory);
    end
endmodule