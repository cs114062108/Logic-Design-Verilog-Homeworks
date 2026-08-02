`timescale 1ns/1ps

// ==================================================================
// Module Name: hw2_1_testbench_0
// Description: Exhaustive Testbench for 1-to-3 Tri-State DEMUX
//              Tests all input patterns of A (0, 1) and S(00..11)
// ==================================================================

module hw2_1_testbench_0;
    // Inputs:
    reg       A;
    reg [1:0] S;

    // Outputs:
    wire X, Y, Z;

    // Instantiate the DEMUX (UUT)
    DEMUX U_D0(
        .A(A),
        .S(S),
        .X(X), .Y(Y), .Z(Z)
    );

    // Variables for iteration:
    integer i, j;

    // Setup waveform
    initial begin
        $dumpfile("waves/HW2_1_0.vcd");
        $dumpvars(0, hw2_1_testbench_0);
    end

    // Test
    initial begin
        $display("============================================================");
        $display("          Starting Tri-State DEMUX Simulation");
        $display("============================================================");

        // Format Specifications:
        // %d: prints unsigned decimal value
        // %0d with $signed(): prints signed decimal representation
        // %b: prints 8-bit binary to easily observe the MSB (Sign Bit)
        $display("-------------------------------------------------------------");
        $display("Time\t A\t S (Binary/Decimal)\t |  X\t Y\t Z");
        $display("-------------------------------------------------------------");
        $monitor("%0dns\t %b\t %b (%d)\t\t\t |  %b\t %b\t %b",
                 $time,
                 A, S, S,
                 X, Y, Z);

        // -- Test all testcases --
        // Iterate through all possible input A [0, 1]
        for (i = 0; i < 2; i = i + 1) begin
            A = i[0];
            // Iterate through all possible control S [00, 01, 10, 11]
            for (j = 0; j < 4; j = j + 1) begin
                S = j[1:0];
                #10;
            end
        end

        $display("-------------------------------------------------------------");
        $display("============================================================");
        $display("               DEMUX Simulation Finished!");
        $display("============================================================");
        $finish();
    end
endmodule
