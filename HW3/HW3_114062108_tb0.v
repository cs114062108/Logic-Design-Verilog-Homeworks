`timescale 1ns/1ps

module Warn_Pattern_tb0;
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg in = 1'b0;
    wire [1:0] out;

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
        .out (out)
    );

    // this blocks is for creating the waveform
    initial begin
        $dumpfile("waves/HW3_result.vcd");
        $dumpvars(0, Warn_Pattern_tb0);
    end

    // do the testpatterns here
    // Variables for file loading
    integer file;
    integer r_cnt, r_seq;
    reg [3:0] A, B, C, D;
    reg [15:0] buff_cnt;
    
    // Load the pattern file
    initial begin
        file = $fopen("./HW3/HW3_pat0.dat", "r");
        r_cnt = $fscanf(file, "%b", buff_cnt);
        {A, B, C, D} = buff_cnt;
        $display("----------------------------------------------");
        $display("              File Load Test");
        $display("----------------------------------------------");
        $display("A = %04b, B = %04b, C = %04b, D = %04b", A, B, C, D);
        $display("A = %d, B = %d, C = %d, D = %d", A, B, C, D);
        $display("----------------------------------------------");
        $display("\n");
        $fclose(file);
    end
    
    // the testpattern designs 
    initial begin
        //..write more code here ...//
        $display("----------------------------------------------");
        $display("Time\t CLK\t rst_n\t in\t | \t out ");
        $display("----------------------------------------------");
        $monitor("%0dns\t %b\t %b\t %b\t | \t %02b ", $time, clk, rst_n, in, out);

        rst_n <= 1;
        in <= 0;

        @(negedge clk);
        rst_n <= 1;

        @(negedge clk);
        rst_n <= 0;

        @(negedge clk);
        rst_n <= 1;
        in <= 1;

        @(negedge clk);
        in <= 0;

        @(negedge clk);
        in <= 1;

        @(negedge clk);
        in <= 1;

        @(negedge clk);
        in <= 0;

        @(negedge clk);
        @(negedge clk);

        @(negedge clk);
        in <= 0;

        @(negedge clk);
        in <= 1;

        @(negedge clk);
        in <= 1;

        @(negedge clk);
        in <= 0;

        @(negedge clk);
        in <= 1;

        @(negedge clk);
        in <= 1;

        @(negedge clk);
        rst_n <= 0;
        in <= 0;

        @(negedge clk);
        rst_n <= 1;

        @(negedge clk);
        @(negedge clk);
        $display("----------------------------------------------");
        $finish();
    end

endmodule
