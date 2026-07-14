// =================================================================
// Module Name: hazard_circuit_0
// Description: Implements F = A(~B) + BC using gate-level modeling
//              with explicit delays (#2 = 2ns) to simulate hazards.
// =================================================================

`timescale 1ns/1ps // Added: Explicitly set timescale to match the testbench!

module hazard_circuit_0(
    input  wire A, 
    input  wire B, 
    input  wire C, 
    output wire F
);

    // Internal wires connecting the gates
    wire not_B;
    wire term1;
    wire term2;

    // Introduce 2ns delay for each gate to expose the hazard
    not #2 g1(not_B, B);        // Inverter with 2ns delay
    and #2 g2(term1, A, not_B); // AND gate 1 with 2ns delay
    and #2 g3(term2, B, C);     // AND gate 2 with 2ns delay
    or  #2 g4(F, term1, term2); // OR gate with 2ns delay

endmodule
