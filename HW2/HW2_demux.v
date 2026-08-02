`timescale 1ns/1ps

module DEMUX( 
    input  wire       A, 
    input  wire [1:0] S, 
    output wire X, Y, Z
); 

    assign X = (S == 2'b01) ? A : 1'bz;
    assign Y = (S == 2'b10) ? A : 1'bz;
    assign Z = (S == 2'b11) ? A : 1'bz;

endmodule
