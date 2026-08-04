`timescale 1ns/1ps

module SRLatch(
    input  wire S,
    input  wire R,
    output wire Q,
    output wire nQ
);

    wire nS, nR;

    not (nS, S);
    not (nR, R);

    nand #2 (Q, nS, nQ);
    nand #2 (nQ, nR, Q);

endmodule
