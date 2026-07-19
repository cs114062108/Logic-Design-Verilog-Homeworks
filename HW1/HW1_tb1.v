`timescale 1ns/1ps

// =================================================================
// Module Name: hw1_testbench_1
// Description: Exhaustive Self-Checking Testbench for 8-bit CLA.
//              Tests all 131,072 input combinations for both
//              addition and subtraction.
//              All comments and display logs are in English.
// =================================================================

module hw1_testbench_1;
    // Inputs: declared as reg to assign values procedurally inside initial block
    reg [7:0] A, B;
    reg       mode; // 0 = Addition, 1 = Subtraction

    // Outputs: declared as wire to receive port mappings from UUT
    wire [7:0] sum;
    wire       c8, overflow;

    // Instantiate 8-bit CLA (UUT)
    CLA_AddSub_8bit U0(
        .a(A), 
        .b(B), 
        .mode(mode), 
        .sum(sum), 
        .c8(c8), 
        .overflow(overflow)
    );

    // -----------------------------------------------------------------
    // Golden Standard Model (Behavioral Reference)
    // -----------------------------------------------------------------
    reg [8:0]  gold_add; // 9-bit to capture carry-out easily
    reg        gold_ov;  // Golden overflow flag
    wire [7:0] b_ctrl = B ^ {8{mode}};

    always @(*) begin
        // Perform the exact same operation as the hardware using high-level behavior
        gold_add = {1'b0, A} + {1'b0, b_ctrl} + mode;
        
        // Signed Overflow: occurs when operands of the same sign produce a result with a different sign
        // Operand 1 sign: A[7]
        // Operand 2 sign: b_ctrl[7]
        // Result sign   : sum[7]
        gold_ov = (A[7] == b_ctrl[7]) && (sum[7] != A[7]);
    end

    // -----------------------------------------------------------------
    // Test Loop Variables
    // -----------------------------------------------------------------
    integer i, j, m;
    integer error_count;
    integer total_tests;

    initial begin
        // Setup waveform dumping directory and file
        $dumpfile("waves/HW1_1.vcd");
        // Dump variables. GTKWave only captures the waves
        $dumpvars(0, hw1_testbench_1);
    end

    initial begin
        $display("=====================================================================================");
        $display("            Starting 8-Bit CLA Exhaustive Self-Checking Testbench");
        $display("            Testing all 131,072 combinations (65,536 ADD / 65,536 SUB)");
        $display("=====================================================================================");
        
        // Format Specifications:
        // %d: prints unsigned decimal value
        // %0d with $signed(): prints signed decimal representation
        // %b: prints 8-bit binary to easily observe the MSB (Sign Bit)
        $display("Begin!");
        $display("------------------------------------------------------------------------------------------------------------------------");
        
        error_count = 0;
        total_tests = 0;

        // Loop through mode: 0 (ADD), 1 (SUB)
        for (m = 0; m < 2; m = m + 1) begin
            mode = m[0];
            
            // Loop through all possible values of A (-128 to 127) using integer
            for (i = -128; i < 128; i = i + 1) begin
                A = i[7:0]; // Safely cast 32-bit integer to 8-bit reg
                
                // Loop through all possible values of B (-128 to 127)
                for (j = -128; j < 128; j = j + 1) begin
                    B = j[7:0];
                    
                    // Wait 1ns for the gate delays to propagate and settle
                    #1; 
                    
                    total_tests = total_tests + 1;

                    // Stop dumping waves after 1000ns to prevent generating a multi-gigabyte VCD file
                    if ($time == 5000) begin
                        $dumpoff;
                    end

                    // ---------------------------------------------------------
                    // Verification Logic
                    // ---------------------------------------------------------
                    if ((sum !== gold_add[7:0]) || (c8 !== gold_add[8]) || (overflow !== gold_ov)) begin
                        error_count = error_count + 1;
                        
                        // Limit console output to first 20 errors to avoid terminal flooding
                        if (error_count <= 20) begin
                            $display("[ERROR @ %0dns] Mode: %s | A: %0d, B: %0d", 
                                    $time, (mode == 1'b0) ? "ADD" : "SUB", $signed(A), $signed(B));
                            $display("         UUT Output   : Sum = %0d (%b), C8 = %b, Overflow = %b", 
                                    $signed(sum), sum, c8, overflow);
                            $display("         Expected Gold: Sum = %0d (%b), C8 = %b, Overflow = %b", 
                                    $signed(gold_add[7:0]), gold_add[7:0], gold_add[8], gold_ov);
                            $display("-----------------------------------------------------------------");
                        end
                    end
                end
            end
        end


        $display("------------------------------------------------------------------------------------------------------------------------");
        $display("Finish!");
        $display("------------------------------------------------------------------------------------------------------------------------");
        $display("   Simulation finished! Please open GTKWave to verify the C7 and C8 relationship.");
        $display("   Total Testcases Executed: %0d", total_tests);
        $display("   Total time used: %0d", $time);
    
        if (error_count == 0) begin
            $display("   ^o^ SUCCESS: All %0d testcases PASSED perfectly!", total_tests);
        end else begin
            $display("   Orz FAILED: Found %0d mismatch errors out of %0d testcases.", error_count, total_tests);
        end
        $display("=====================================================================================");
        $finish;
    end

endmodule
