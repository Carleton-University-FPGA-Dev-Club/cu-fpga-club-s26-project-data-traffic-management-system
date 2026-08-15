`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Design Name: FPGA Traffic Management System
// Module Name: board_top
// Project Name: Data Traffic Management System
// Target Device: Digilent Zybo Z7-20
// Tool Version: Vivado 2025.2
//
// Description:
// Hardware demonstration wrapper for the FPGA traffic management system.
//
// Packet-processing pipeline:
//   Packet Generator -> FIFO Queue -> Packet Inspector -> Traffic Manager
//
// LED demonstration:
//   LD0 - Normal traffic activity pattern
//   LD1 - Suspicious traffic double-flash pattern
//   LD2 - Dropped traffic triple-flash warning pattern
//   LD3 - System heartbeat
//
// BTN0 - Reset
//        Clears packet-processing state, event flags, and LED animation.
//
// The packet-processing hardware operates much faster than the human eye can
// observe. Packet events are therefore latched and displayed using slower,
// human-visible LED animation patterns.
//
// Dependencies:
// top.v
//
// Revision:
// Revision 1.00 - Final integrated project version
//////////////////////////////////////////////////////////////////////////////////

module board_top(
    input  wire       clk,
    input  wire       reset,
    output wire [3:0] led
);


// =============================================================================
// PACKET PROCESSING SYSTEM
// =============================================================================

wire [7:0] normal_count;
wire [7:0] suspicious_count;
wire [7:0] dropped_count;

top system (
    .clk(clk),
    .reset(reset),
    .normal_count(normal_count),
    .suspicious_count(suspicious_count),
    .dropped_count(dropped_count)
);


// =============================================================================
// EVENT MEMORY
// =============================================================================
//
// Once a traffic category has been observed, remember it until reset.
// This allows very fast packet-processing events to be displayed visibly.
//

reg normal_seen;
reg suspicious_seen;
reg dropped_seen;

always @(posedge clk) begin
    if (reset) begin
        normal_seen     <= 1'b0;
        suspicious_seen <= 1'b0;
        dropped_seen    <= 1'b0;
    end
    else begin
        if (normal_count != 8'd0)
            normal_seen <= 1'b1;

        if (suspicious_count != 8'd0)
            suspicious_seen <= 1'b1;

        if (dropped_count != 8'd0)
            dropped_seen <= 1'b1;
    end
end


// =============================================================================
// HUMAN-VISIBLE ANIMATION CLOCK
// =============================================================================
//
// Zybo Z7-20 system clock = 125 MHz.
//
// 12,500,000 clock cycles = 100 ms.
//
// The animation advances once every 100 ms.
// Ten animation steps therefore create a one-second repeating cycle.
//

reg [23:0] animation_counter;
reg [3:0]  animation_step;

always @(posedge clk) begin
    if (reset) begin
        animation_counter <= 24'd0;
        animation_step    <= 4'd0;
    end
    else begin

        if (animation_counter >= 24'd12_499_999) begin
            animation_counter <= 24'd0;

            if (animation_step == 4'd9)
                animation_step <= 4'd0;
            else
                animation_step <= animation_step + 1'b1;
        end
        else begin
            animation_counter <= animation_counter + 1'b1;
        end

    end
end


// =============================================================================
// LED PATTERNS
// =============================================================================


// -----------------------------------------------------------------------------
// LD0 - NORMAL TRAFFIC
//
// Regular alternating activity pattern:
//
// ON OFF ON OFF ON OFF ON OFF ON OFF
// -----------------------------------------------------------------------------

assign led[0] =
    normal_seen &&
    (
        (animation_step == 4'd0) ||
        (animation_step == 4'd2) ||
        (animation_step == 4'd4) ||
        (animation_step == 4'd6) ||
        (animation_step == 4'd8)
    );


// -----------------------------------------------------------------------------
// LD1 - SUSPICIOUS TRAFFIC
//
// Double-flash pattern:
//
// OFF ON OFF ON OFF OFF OFF OFF OFF OFF
// -----------------------------------------------------------------------------

assign led[1] =
    suspicious_seen &&
    (
        (animation_step == 4'd1) ||
        (animation_step == 4'd3)
    );


// -----------------------------------------------------------------------------
// LD2 - DROPPED TRAFFIC
//
// Triple-flash warning pattern:
//
// ON OFF ON OFF ON OFF OFF OFF OFF OFF
// -----------------------------------------------------------------------------

assign led[2] =
    dropped_seen &&
    (
        (animation_step == 4'd0) ||
        (animation_step == 4'd2) ||
        (animation_step == 4'd4)
    );


// -----------------------------------------------------------------------------
// LD3 - SYSTEM HEARTBEAT
//
// ON for approximately 0.5 seconds.
// OFF for approximately 0.5 seconds.
//
// During reset, animation_step is held at zero, so LD3 remains illuminated
// while BTN0 is held.
// -----------------------------------------------------------------------------

assign led[3] = (animation_step < 4'd5);


endmodule
