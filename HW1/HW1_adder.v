`timescale 1ns/1ps

// ===============================================================
// Sub-Module: partial_full_adder (PFA)
// Description: Generates Propagate (P), Generate (G) and Sum (S)
// ===============================================================
module partial_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire p,
    output wire g,
    output wire sum
);
    xor g_p(p, a, b);       // P = A ^ B
    and g_g(g, a, b);       // G = A & B
    xor g_s(sum, p, cin);   // S = P ^ Cin
    
endmodule
