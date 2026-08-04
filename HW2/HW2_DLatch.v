`timescale 1ns/1ps

module part_DLatch(
    input  wire D,
    input  wire nD,
    input  wire G,
    output wire Q,
    output wire nQ
);

    wire S, R;
    and #2 a_S(S, D, G);
    and #2 a_R(R, nD, G);

    SRLatch SRL(.S(S), .R(R), .Q(Q), .nQ(nQ));

endmodule
