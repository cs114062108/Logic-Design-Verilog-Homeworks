`timescale 1ns/1ps

module CLA_AddSub_8bit( 
    input  wire [7:0] a,         // 8-bit input operand a
    input  wire [7:0] b,         // 8-bit input operand b
    input  wire       mode,      // 0 = add, 1 = subtract 
    output wire [7:0] sum,       // 8-bit sum / difference 
    output wire       c8,        // final carry-out  
    output wire       overflow   // signed (two's complement) overflow flag 
);
    
    // 1. Generate 2's complement input for B
    // B_controled[i] = B[i] ^ mode
    wire [7:0] b_ctrl;
    xor g_b_ctrl0(b_ctrl[0], b[0], mode);
    xor g_b_ctrl1(b_ctrl[1], b[1], mode);
    xor g_b_ctrl2(b_ctrl[2], b[2], mode);
    xor g_b_ctrl3(b_ctrl[3], b[3], mode);
    xor g_b_ctrl4(b_ctrl[4], b[4], mode);
    xor g_b_ctrl5(b_ctrl[5], b[5], mode);
    xor g_b_ctrl6(b_ctrl[6], b[6], mode);
    xor g_b_ctrl7(b_ctrl[7], b[7], mode);

    // Internal block interconnect carries
    wire c4; // Carry out from lower 4-bit CLA to upper 4-bit CLA
    wire c7; // Carry into the last bit (bit 7) - used for overflow check

    // 2. Instantiate Lower 4-bit CLA Block (Bits 0-3)
    // Initial carry-in is 'mode' (0 for Addition, 1 for Subtraction)
    CLA_4bit lower_cla(
        .a(a[3:0]), 
        .b(b_ctrl[3:0]), 
        .cin(mode), 
        .sum(sum[3:0]), 
        .cout(c4),
        .c3() // Unused for lower block
    );

    // 3. Instantiate Upper 4-bit CLA Block (Bits 4-7)
    // Carry in is 'c4'
    CLA_4bit upper_cla(
        .a(a[7:4]),
        .b(b_ctrl[7:4]),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(c8),
        .c3(c7) // Connect to c7 for overflow detection
    );

    // 4. Calculate Signed Overflow
    // Overflow occurs when carry-in to MSB (c7) is different from carry-out of MSB (c8)
    xor g_ovfl(overflow, c7, c8);

endmodule
