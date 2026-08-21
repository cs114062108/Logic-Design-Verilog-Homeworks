`timescale 1ns/1ps

module Warn_Pattern (
    input  wire clk, rst_n,
    input  wire in,
    output reg  [1:0] out
);
    // ---------------------------------
    // FSM State Definitons
    // ---------------------------------
    localparam IDLE = 4'b0000; // IDLE State
    localparam S1   = 4'b0001; // Received pattern: 1
    localparam S2   = 4'b0010; // Received pattern: 10
    localparam S3   = 4'b0011; // Received pattern: 101
    localparam S4   = 4'b0100; // Received pattern: 1011
    localparam S5   = 4'b0101; // Received pattern: 0
    localparam S6   = 4'b0110; // Received pattern: 01
    localparam S7   = 4'b0111; // Received pattern: 011
    localparam S8   = 4'b1000; // Received pattern: 0110

    // State
    reg [3:0] state;
    reg [3:0] next_state;

    // Combinational asychronous reset
    reg rst; // asynchronous rst

    // --------------------------------------
    // FSM State Register (Sequential)
    // --------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            rst <= 1'b0;
        end else begin
            state <= next_state;
            rst <= 1'b1;
        end
    end

    // TODO: state encoding
    // ----------------------------------------------------------
    // FSM Next State Logic (Combinational)
    // ----------------------------------------------------------
    always @(*) begin
        case (state)
            IDLE: begin // IDLE State
                if (in == 1'b0) begin
                    next_state = S5; // next pattern: 0
                end else begin
                    next_state = S1; // next pattern: 1
                end
            end

            S1: begin   // Received Pattern: 1
                if (in == 1'b0) begin
                    next_state = S2; // next pattern: 10
                end else begin
                    next_state = S1; // next pattern: 11
                end
            end

            S2: begin   // Received Pattern: 10
                if (in == 1'b0) begin
                    next_state = S5; // next pattern: 0
                end else begin
                    next_state = S3; // next pattern: 101
                end
            end

            S3: begin   // Received Pattern: 101
                if (in == 1'b0) begin
                    next_state = S2; // next pattern: 10
                end else begin
                    next_state = S4; // next pattern: 1011
                end
            end

            S4: begin   // Received Pattern: 1011
                if (in == 1'b0) begin
                    next_state = S8; // next pattern: 0110
                end else begin
                    next_state = S1; // next pattern: 1
                end
            end

            S5: begin   // Received Pattern: 0
                if (in == 1'b0) begin
                    next_state = S5; // next pattern: 0
                end else begin
                    next_state = S6; // next pattern: 01
                end
            end

            S6: begin   // Received Pattern: 01
                if (in == 1'b0) begin
                    next_state = S2; // next pattern: 10
                end else begin
                    next_state = S7; // next pattern: 011
                end
            end

            S7: begin   // Received Pattern: 011
                if (in == 1'b0) begin
                    next_state = S8; // next pattern: 0110
                end else begin
                    next_state = S1; // next pattern: 1
                end
            end

            S8: begin   // Received Pattern: 0110
                if (in == 1'b0) begin
                    next_state = S5; // next pattern: 0
                end else begin
                    next_state = S3; // next pattern: 101
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // TODO: write more code
    // ----------------------------------------------------------
    // Moore FSM Output Assignment (Combinational)
    // ----------------------------------------------------------
    always @(*) begin
        case (state)
            IDLE: begin
                if (!rst) begin
                    out = 2'b11;
                end else begin
                    out = 2'b00;
                end
            end

            S4: begin   // Detected 1011
                out = 2'b01;
            end

            S8: begin   // Detected 0110
                out = 2'b01;
            end

            default: begin
                out = 2'b00;
            end
        endcase
    end

endmodule
