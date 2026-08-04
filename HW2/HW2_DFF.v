`timescale 1ns/1ps

module ne_DFF(
    input  wire D,
    input  wire CLK,
    output wire Q,
    output wire nQ
);

    wire nD;
    not (nD, D);

    wire Q1, nQ1;

    part_DLatch m_D(.D(D), .nD(nD), .G(CLK), .Q(Q1), .nQ(nQ1));

    wire nCLK;
    not (nCLK, CLK);

    part_DLatch s_D(.D(Q1), .nD(nQ1), .G(nCLK), .Q(Q), .nQ(nQ));

endmodule
