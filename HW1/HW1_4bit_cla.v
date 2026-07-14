`timescale 1ns/1ps

// ==============================================================
// Sub-Module: cla_4bit (4-Bit Carry Lookahead Adder Block)
// Description: Performs 4-bit carry lookahead addition.
//              Exposes 'c3' (carry into MSB) for overflow check
// ==============================================================
module CLA_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout,
    output wire       c3     // Exposed internal carry into bit 3 (for C7 overflow check)
);
    // Propagate and Generate signals
    wire p0, p1, p2, p3;
    wire g0, g1, g2, g3;
    //wire c1, c2;

    // Instantiate 1-bit partial full adders
    partial_full_adder pfa0(.a(a[0]), .b(b[0]), .cin(cin), .p(p0), .g(g0), .sum(sum[0]));
    partial_full_adder pfa1(.a(a[1]), .b(b[1]), .cin(c1),  .p(p1), .g(g1), .sum(sum[1]));
    partial_full_adder pfa2(.a(a[2]), .b(b[2]), .cin(c2),  .p(p2), .g(g2), .sum(sum[2]));
    partial_full_adder pfa3(.a(a[3]), .b(b[3]), .cin(c3),  .p(p3), .g(g3), .sum(sum[3]));

    // --------------------------------------------------------
    // Internal wires for carry lookahead generator term logic
    // --------------------------------------------------------
    // C1 logic terms
    wire p0_cin;

    // C2 logic terms
    wire p1_g0;
    wire p1_p0_cin;

    // C3 logic terms
    wire p2_g1;
    wire p2_p1_g0;
    wire p2_p1_p0_cin;

    // C4 (Cout) logic terms
    wire p3_g2;
    wire p3_p2_g1;
    wire p3_p2_p1_g0;
    wire p3_p2_p1_p0_cin;

    // -----------------------------------------------------
    // Gate-level Carry Generation Logic
    // -----------------------------------------------------

    // C1 = G0 + P0*Cin
    and a_c1_0(p0_cin, p0, cin);
    or  o_c1(c1, g0, p0_cin);

    // C2 = G1 + P1*G0 + P1*P0*Cin
    and a_c2_0(p1_g0, p1, g0);
    and a_c2_1(p1_p0_cin, p1, p0, cin);
    or  o_c2(c2, g1, p1_g0, p1_p0_cin);

    // C3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin
    and a_c3_0(p2_g1, p2, g1);
    and a_c3_1(p2_p1_g0, p2, p1, g0);
    and a_c3_2(p2_p1_p0_cin, p2, p1, p0, cin);
    or  o_c3(c3, g2, p2_g1, p2_p1_g0, p2_p1_p0_cin);

    // C4 (Cout) = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*Cin
    and a_c4_0(p3_g2, p3, g2);
    and a_c4_1(p3_p2_g1, p3, p2, g1);
    and a_c4_2(p3_p2_p1_g0, p3, p2, p1, g0);
    and a_c4_3(p3_p2_p1_p0_cin, p3, p2, p1, p0, cin);
    or  o_c4(cout, g3, p3_g2, p3_p2_g1, p3_p2_p1_g0, p3_p2_p1_p0_cin);

endmodule
