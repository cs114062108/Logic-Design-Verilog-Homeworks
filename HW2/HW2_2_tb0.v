`timescale 1ns/1ps

module hw2_2_testbench_0;

    // Inputs to the UUT
    reg clk;
    reg D;

    // Outputs from the UUT
    wire Q, nQ;

    // Instatiate the neg-edge triggered D Flip Flop
    ne_DFF U_DFF0(
        .CLK(clk),
        .D(D),
        .Q(Q), .nQ(nQ)
    );

    // -----------------------------------------------
    // Clock generater
    // -----------------------------------------------
    initial begin
        clk = 1'b1;
    end
    always #10 begin
        clk = ~clk; // Toggle clock every 10ns
    end

    // -----------------------------------------------
    // Stimulus Process
    // -----------------------------------------------
    
    // Setup waveform dumping for GTKWave
    initial begin
        $dumpfile("waves/HW2_2_0.vcd");
        $dumpvars(0, hw2_2_testbench_0);
    end

    initial begin
        // Display console logs
        $display("-----------------------------------------------");
        $display("Time\t CLK\t D\t | \tQ\t nQ");
        $display("-----------------------------------------------");
        $monitor("\%0dns\t %b\t %b\t | \t%b\t %b", $time, clk, D, Q, nQ);

        // Initial setup
        D = 1'b0;
        #10; // Setup before first neg-edge (which happens at 10ns, next at 30ns)

        // --- Testcase 1: D=1 with sufficient Setup Time (>6ns) ---
        // Neg-edge will occur at t = 30ns.
        // Changing D at t = 20ns gives 10ns setup time.
        #10;
        D = 1'b1; 
        #10; // At t=30ns (CLK falling edge), Q should update to 1 after 6ns or 4ns (at t=36ns or t=34ns).

        // --- Testcase 2: D=0 with sufficient Setup Time ---
        // Next neg-edge at t = 50ns.
        // Changing D at t = 40ns gives 10ns setup time.
        #10;
        D = 1'b0;
        #10; // At t=50ns (CLK falling edge), Q should update to 0 after 6ns (at t=56ns).

        // --- Testcase 3: Setup Time Violation (<6ns) ---
        // Next neg-edge at t = 70ns.
        // Changing D at t = 68ns gives only 2ns setup time (<6ns requirement).
        #18;
        D = 1'b1; // t = 68ns
        #2;

        // --- Testcase 4: D=0 with sufficient Setup Time, after violation ---
        // Next neg-edge at t = 90ns.
        // Changing D at t = 82ns gives 8ns setup time.
        #12;
        D = 1'b0; // t = 82ns
        #18;

        #10;
        $display("-----------------------------------------------");
        $finish();
    end

endmodule
