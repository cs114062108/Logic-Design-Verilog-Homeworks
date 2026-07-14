`timescale 1ns/1ps

module hazard_testbench_0;
    reg A, B, C;
    wire F;

    hazard_circuit_0 U0(A, B, C, F);

    initial begin
        $dumpfile("waves/Hazard0.vcd");
        $dumpvars(0, hazard_testbench_0);
    end

    initial begin
        $display("Begin!");
        $display("------------------------");

        // Display header in console
        $display("Time\t A B C |  F");
        $monitor("%0dns\t %b %b %b |  %b", $time, A, B, C, F);

        {A, B, C} = 3'b000; #10;
        {A, B, C} = 3'b111; #10;
        {A, B, C} = 3'b101; #10;
        {A, B, C} = 3'b111; #10;

        $display("------------------------");
        $display("Finish!");
        $finish;
    end
endmodule
