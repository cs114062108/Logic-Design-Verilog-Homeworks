`timescale 1ns/1ps

module Warn_Pattern_1 (
    input  wire clk, rst_n,
    input  wire in,
    output reg  [1:0] out
);
    // ---------------------------------
    // FSM State Definitons
    // ---------------------------------
    localparam IDLE = 3'b000; // IDLE State
    localparam S1   = 3'b001; // Received pattern: 1
    localparam S2   = 3'b010; // Received pattern: 10  or 0110
    localparam S3   = 3'b011; // Received pattern: 101
    localparam S4   = 3'b100; // Received pattern: 0
    localparam S5   = 3'b101; // Received pattern: 01
    localparam S6   = 3'b110; // Received pattern: 011 or 1011

    reg [2:0] state;
    reg [2:0] next_state;

    reg [1:0] next_out;

    // TODO: write more code
    // --------------------------------------
    // FSM State Register (Sequential)
    // --------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            out <= 2'b11;
        end else begin
            state <= next_state;
            out <= next_out;
        end
    end

    // TODO: state encoding
    // ----------------------------------------------------------
    // FSM Next State Logic & Output Assignments (Combinational)
    // ----------------------------------------------------------
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = S4;
                    next_out = 2'b00;
                end else begin
                    next_state = S1;
                    next_out = 2'b00;
                end
            end

            S1: begin
                if (in == 1'b0) begin
                    next_state = S2;
                    next_out = 2'b00;
                end else begin
                    next_state = S1;
                    next_out = 2'b00;
                end
            end
            
            S2: begin
                if (in == 1'b0) begin
                    next_state = S4;
                    next_out = 2'b00;
                end else begin
                    next_state = S3;
                    next_out = 2'b00;
                end
            end

            S3: begin
                if (in == 1'b0) begin
                    next_state = S2;
                    next_out = 2'b00;
                end else begin
                    next_state = S6;
                    next_out = 2'b01;
                end
            end

            S4: begin
                if (in == 1'b0) begin
                    next_state = S4;
                    next_out = 2'b00;
                end else begin
                    next_state = S5;
                    next_out = 2'b00;
                end
            end

            S5: begin
                if (in == 1'b0) begin
                    next_state = S2;
                    next_out = 2'b00;
                end else begin
                    next_state = S6;
                    next_out = 2'b00;
                end
            end

            S6: begin
                if (in == 1'b0) begin
                    next_state = S2;
                    next_out = 2'b01;
                end else begin
                    next_state = S1;
                    next_out = 2'b00;
                end
            end

            default: begin
                next_state = IDLE;
                next_out = 2'b00;
            end
        endcase
    end

endmodule
