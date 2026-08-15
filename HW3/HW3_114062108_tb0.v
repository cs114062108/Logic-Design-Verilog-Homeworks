`timescale 1ns/1ps

module Warn_Pattern_tb0;
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg in = 1'b0;
    wire [1:0] out;

    // specify duration of a clock cycle.
    parameter cyc = 10;

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
        $dumpfile("HW3_result.vcd");
        $dumpvars(0, Warn_Pattern_tb0);
    end

    // do the testpatterns here
    // the testpattern designs 
    initial begin
        //..write more code here ...//
    end

endmodule
