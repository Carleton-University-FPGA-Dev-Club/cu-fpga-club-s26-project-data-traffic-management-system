`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Design Name: FPGA Traffic Management System
// Module Name: top
// Project Name: Data Traffic Management System
// Target Device: Digilent Zybo Z7-20
// Tool Version: Vivado 2025.2
//
// Description:
// Integrates the complete FPGA packet-processing pipeline.
//
// Processing flow:
//
//   Packet Generator
//          |
//          v
//      FIFO Queue
//          |
//          v
//   Packet Inspector
//          |
//          v
//   Traffic Manager
//
// The Packet Generator creates simulated 16-bit network packets.
// The FIFO Queue buffers packets using First-In-First-Out ordering.
// The Packet Inspector classifies packets as normal, suspicious,
// or malformed.
// The Traffic Manager counts normal and suspicious packets and drops
// malformed or excess suspicious traffic.
//
// Dependencies:
// packet_generator.v
// fifo_queue.v
// packet_inspector.v
// traffic_manager.v
//
// Revision:
// Revision 1.00 - Final integrated project version
//////////////////////////////////////////////////////////////////////////////////

module top(
    input  wire       clk,
    input  wire       reset,

    output wire [7:0] normal_count,
    output wire [7:0] suspicious_count,
    output wire [7:0] dropped_count
);


// =============================================================================
// PACKET GENERATOR SIGNALS
// =============================================================================

wire [15:0] packet_data;
wire        packet_valid;


// =============================================================================
// FIFO SIGNALS
// =============================================================================

wire [15:0] fifo_data_out;
wire        fifo_data_valid;
wire        fifo_full;
wire        fifo_empty;


// =============================================================================
// PACKET INSPECTOR SIGNALS
// =============================================================================

wire suspicious;
wire malformed;


// =============================================================================
// TRAFFIC MANAGER VALID SIGNAL
// =============================================================================
//
// packet_inspector registers its classification result on a rising clock edge.
// manager_valid delays the FIFO valid signal by one clock cycle so the Traffic
// Manager processes the classification corresponding to the correct packet.
//

reg manager_valid;

always @(posedge clk) begin
    if (reset)
        manager_valid <= 1'b0;
    else
        manager_valid <= fifo_data_valid;
end


// =============================================================================
// PACKET GENERATOR
// =============================================================================

packet_generator gen (
    .clk(clk),
    .reset(reset),
    .packet_data(packet_data),
    .packet_valid(packet_valid)
);


// =============================================================================
// FIFO QUEUE
// =============================================================================

fifo_queue fifo (
    .clk(clk),
    .reset(reset),

    .write_enable(packet_valid),
    .data_in(packet_data),

    // Continuously process packets whenever the FIFO contains data.
    .read_enable(!fifo_empty),
    .data_out(fifo_data_out),
    .data_valid(fifo_data_valid),

    .full(fifo_full),
    .empty(fifo_empty)
);


// =============================================================================
// PACKET INSPECTOR
// =============================================================================

packet_inspector inspect (
    .clk(clk),
    .reset(reset),

    .packet_data(fifo_data_out),
    .packet_valid(fifo_data_valid),

    .suspicious(suspicious),
    .malformed(malformed)
);


// =============================================================================
// TRAFFIC MANAGER
// =============================================================================

traffic_manager manager (
    .clk(clk),
    .reset(reset),

    .packet_valid(manager_valid),
    .suspicious(suspicious),
    .malformed(malformed),

    .normal_count(normal_count),
    .suspicious_count(suspicious_count),
    .dropped_count(dropped_count)
);

endmodule
