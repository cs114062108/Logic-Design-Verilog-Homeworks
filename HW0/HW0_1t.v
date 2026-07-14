`timescale 1ns/1ps

module testbench;
    reg A, B, C, D;
    wire F;
    
    circuit_1 U0(A, B, C, D, F);

    initial begin
        $dumpfile("waves/HW0_1.vcd");
        $dumpvars(0, testbench);
    end
    
    initial begin
        $display("Begin!");
        $display("------------------------");

        // Display header in console
        $display("Time\t A B C D |  F");
        $monitor("%0dns\t %b %b %b %b |  %b", $time, A, B, C, D, F);
        
        {A, B, C, D} = 4'b0000;
        #(10) {A, B, C, D} = 4'b0001;
        #(10) {A, B, C, D} = 4'b0010;
        #(10) {A, B, C, D} = 4'b0011;
        #(10) {A, B, C, D} = 4'b0100;
        #(10) {A, B, C, D} = 4'b0101;
        #(10) {A, B, C, D} = 4'b0110;
        #(10) {A, B, C, D} = 4'b0111;
        #(10) {A, B, C, D} = 4'b1000;
        #(10) {A, B, C, D} = 4'b1001;
        #(10) {A, B, C, D} = 4'b1010;
        #(10) {A, B, C, D} = 4'b1011;
        #(10) {A, B, C, D} = 4'b1100;
        #(10) {A, B, C, D} = 4'b1101;
        #(10) {A, B, C, D} = 4'b1110;
        #(10) {A, B, C, D} = 4'b1111;

        $display("------------------------");
        $display("Finish!");
        $finish;
    end
endmodule
