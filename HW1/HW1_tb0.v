`timescale 1ns/1ps

// Module Name: hw1_testbench_9
// Description: Testbench for 8-bit CLA Adder/Subtractor

module hw1_testbench_0;
    // Inputs: declared as reg to assign values procedurally inside initial block
    reg [7:0] A, B;
    reg       mode; // 0 = Addition, 1 = Subtraction

    // Outputs: declared as wire to receive port mappings from UUT
    wire [7:0] sum;
    wire       c8, overflow;

    // -----------------------------------------------------------------
    // Workaround for iverilog $monitor limitation:
    // Create intermediate nets for complex expressions and system tasks.
    // -----------------------------------------------------------------
    // 1. Declare signed wires so that $monitor automatically prints them as signed decimal
    wire signed [7:0] A_signed   = A;
    wire signed [7:0] B_signed   = B;
    wire signed [7:0] sum_signed = sum;

    // 2. Declare a 32-bit (4-byte) wire to hold "ADD " or "SUB " string
    wire [31:0] mode_str = (mode == 1'b0) ? "ADD " : "SUB ";

    // Instantiate 8-bit CLA (UUT)
    CLA_AddSub_8bit U0(
        .a(A), 
        .b(B), 
        .mode(mode), 
        .sum(sum), 
        .c8(c8), 
        .overflow(overflow)
    );

    initial begin
        // Setup waveform dumping directory and file
        $dumpfile("waves/HW1_0.vcd");
        $dumpvars(0, hw1_testbench_0);
    end

    initial begin
        $display("=====================================================================================");
        $display("            Starting 8-Bit CLA Adder/Subtractor Test (Signed 2's Comp)");
        $display("=====================================================================================");
        
        // Format Specifications:
        // %d: prints unsigned decimal value
        // %0d with $signed(): prints signed decimal representation
        // %b: prints 8-bit binary to easily observe the MSB (Sign Bit)
        $display("Begin!");
        $display("Time\t Mode\t Input A (Signed/Binary)       Input B (Signed/Binary)       |  Output S (Signed/Binary)   C8  Overflow");
        $display("------------------------------------------------------------------------------------------------------------------------");
        
        $monitor("%0dns\t %s\t %4d (%b)\t      %4d (%b)  \t\t     |  %4d (%b)\t           %b\t   %b", 
                 $time, 
                 mode_str,
                 A_signed, A, 
                 B_signed, B, 
                 sum_signed, sum, 
                 c8, overflow);
        
        // -----------------------------------------------------------------
        // Testcase 1: Simple positive addition (50 + 30 = 80)
        // Expected: sum = 80, overflow = 0 (within signed range -128 to +127)
        // -----------------------------------------------------------------
        mode = 1'b0; A = 8'd50; B = 8'd30; #10;

        // -----------------------------------------------------------------
        // Testcase 2: Positive plus negative (50 + (-30) = 20)
        // Assign negative decimal; Verilog automatically handles 2's complement conversion
        // Expected: sum = 20, overflow = 0
        // -----------------------------------------------------------------
        mode = 1'b0; A = 8'd50; B = -8'd30; #10;

        // -----------------------------------------------------------------
        // Testcase 3: Positive addition leading to positive overflow (100 + 40 = 140)
        // 140 exceeds the max signed value +127. Binary wraps to 8'b1000_1100 (-116)
        // Expected: sum = -116, overflow = 1
        // -----------------------------------------------------------------
        mode = 1'b0; A = 8'd100; B = 8'd40; #10;

        // -----------------------------------------------------------------
        // Testcase 4: Negative addition leading to negative overflow (-100 + (-40) = -140)
        // -140 falls below the min signed value -128. Binary wraps to positive value.
        // Expected: sum = 116, overflow = 1
        // -----------------------------------------------------------------
        mode = 1'b0; A = -8'd100; B = -8'd40; #10;

        // -----------------------------------------------------------------
        // Testcase 5: Simple subtraction (50 - 30 = 20)
        // Expected: sum = 20, overflow = 0
        // -----------------------------------------------------------------
        mode = 1'b1; A = 8'd50; B = 8'd30; #10;

        // -----------------------------------------------------------------
        // Testcase 6: Subtraction leading to overflow (100 - (-50) = 150)
        // Subtracting a negative is equivalent to adding a positive. 150 > 127
        // Expected: sum = -106, overflow = 1
        // -----------------------------------------------------------------
        mode = 1'b1; A = 8'd100; B = -8'd50; #10;

        // -----------------------------------------------------------------
        // Testcase 7: Negative minus positive leading to overflow (-100 - 50 = -150)
        // -150 < -128
        // Expected: sum = 106, overflow = 1
        // -----------------------------------------------------------------
        mode = 1'b1; A = -8'd100; B = 8'd50; #10;

        $display("------------------------------------------------------------------------------------------------------------------------");
        $display("Finish!");
        $display("------------------------------------------------------------------------------------------------------------------------");
        $display("   Simulation finished! Please open GTKWave to verify the C7 and C8 relationship.");
        $display("=====================================================================================");
        $finish;
    end

endmodule
