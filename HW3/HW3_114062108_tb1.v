`timescale 1ns/1ps
`define NUM_OF_PAT 2
`define MAX_CNT    16

module Warn_Pattern_tb1;
    // inputs
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg in = 1'b0;
    
    // outputs
    wire [1:0] out0;
    wire [1:0] out1;

    // specify duration of a clock cycle.
    parameter cyc = 10;
    parameter c = 5;

    // generate clock.
    always #(cyc/2) clk = ~clk;

    // the module that you designed
    Warn_Pattern WP (
        .clk (clk),
        .rst_n (rst_n),
        .in (in),
        .out (out0)
    );
    
    Warn_Pattern_1 WP1 (
        .clk (clk),
        .rst_n (rst_n),
        .in (in),
        .out (out1)
    );

    // this blocks is for creating the waveform
    initial begin
        $dumpfile("waves/HW3_result_1.vcd");
        $dumpvars(0, Warn_Pattern_tb1);
    end

    // do the testpatterns here
    // Variables and registers for file loading
    reg [7:0] cnt_reg [0:`NUM_OF_PAT-1];
    reg in_reg [0:`NUM_OF_PAT*`MAX_CNT];
    reg rst_n_reg [0:`NUM_OF_PAT*`MAX_CNT];

    integer file;
    integer r_cnt, r_seq; // for scanning file
    reg [7:0] buff_cnt;
    reg [2:0] buff_seq;

    integer pat, cnt, idx; // for iterating
    
    // test
    integer r_test;
    reg [3:0] A, B, C, D;
    reg [15:0] buff_test;
    
    // Load the pattern file
    initial begin
        file = $fopen("./HW3/HW3_pat0.dat", "r");
        r_test = $fscanf(file, "%b", buff_test);
        {A, B, C, D} = buff_test;
        $display("----------------------------------------------");
        $display("              File Load Test");
        $display("----------------------------------------------");
        $display("A = %04b, B = %04b, C = %04b, D = %04b", A, B, C, D);
        $display("A = %d, B = %d, C = %d, D = %d", A, B, C, D);
        $display("----------------------------------------------");
        $display("\n");
        $display("----------------------------------------------");
        $display("              Loading patters");
        idx = 0;
        for (pat = 0; pat < `NUM_OF_PAT; pat = pat + 1) begin
            r_cnt = $fscanf(file, "%h", buff_cnt);
            cnt_reg[pat] = buff_cnt;
            $display("count = %d", cnt_reg[pat]);
            for (cnt = 0; cnt < cnt_reg[pat]; cnt = cnt + 1) begin
                $display("BBBBBBBBBBBBBBBB");
                r_seq = $fscanf(file, "%b", buff_seq);
                $display("AAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                {in_reg[idx], rst_n_reg[idx]} = buff_seq;
                $display("in = %b, rst_n = %b", in_reg[idx], rst_n_reg[idx]);
                idx = idx + 1;
            end
        end
        $fclose(file);
        $display("----------------------------------------------");
        $display("\n");
    end
    
    // the testpattern designs 
    initial begin
        //..write more code here ...//
        $display("------------------------------------------------------");
        $display("Time\t CLK\t rst_n\t in\t | \t out0 \t out1 ");
        $display("------------------------------------------------------");
        $monitor("%0dns\t %b\t %b\t %b\t | \t %02b \t %02b", $time, clk, rst_n, in, out0, out1);

        // --- Init and reset ---
        rst_n = 1;
        in = 0;
        
        @(negedge clk); // 5 ns
        rst_n = 1;      // 10 ns

        @(negedge clk); // 15 ns
        rst_n = 0;      // 20 ns

        // --- Test Pattern: 1 -> 0 -> 1 -> 1 -> 0 -> 0 ---
        @(negedge clk); // 25 ns
        rst_n = 1;      // 30 ns
        in = 1;

        @(negedge clk); // 35 ns
        in = 0;         // 40 ns

        @(negedge clk); // 45 ns
        in = 1;         // 50 ns

        @(negedge clk); // 55 ns
        in = 1;         // 60 ns

        @(negedge clk); // 65 ns
        in = 0;         // 70 ns

        // --- Test patterns from the dat file --
        idx = 0;
        for (pat = 0; pat < `NUM_OF_PAT; pat = pat + 1) begin
            @(negedge clk); 
            @(negedge clk);
            // wait a full clk period for the next pattern
            for (cnt = 0; cnt < cnt_reg[pat]; cnt = cnt + 1) begin
                @(negedge clk);
                in = in_reg[idx];
                rst_n = rst_n_reg[idx];
                idx = idx + 1;
            end
        end

        // --- End of tests ---
        @(negedge clk); // 175 ns
        @(negedge clk); // 185 ns
        $display("------------------------------------------------------");
        $finish();
    end

endmodule
