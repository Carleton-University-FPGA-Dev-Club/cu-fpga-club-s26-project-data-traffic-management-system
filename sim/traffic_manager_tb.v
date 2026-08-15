`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Create Date: 06/03/2026 05:36:27 PM
// Design Name: FPGA Traffic Management System
// Module Name: traffic_manager_tb
// Project Name: Data Traffic Management System
// Target Device: Digilent Zybo Z7-20
// Tool Version: Vivado 2025.2
//
// Description:
// Testbench for the traffic manager.
//
// Verifies:
//   - Reset behavior
//   - Normal packet counting
//   - Suspicious packet counting
//   - Immediate dropping of malformed packets
//   - Suspicious packet threshold behavior
//
// Dependencies:
// traffic_manager.v
//
// Revision:
// Revision 1.00 - Final integrated project version
//////////////////////////////////////////////////////////////////////////////////

module traffic_manager_tb;

reg clk;
reg reset;
reg packet_valid;
reg suspicious;
reg malformed;

wire [7:0] normal_count;
wire [7:0] suspicious_count;
wire [7:0] dropped_count;

integer i;

traffic_manager uut (
    .clk(clk),
    .reset(reset),
    .packet_valid(packet_valid),
    .suspicious(suspicious),
    .malformed(malformed),
    .normal_count(normal_count),
    .suspicious_count(suspicious_count),
    .dropped_count(dropped_count)
);

// 100 MHz simulation clock.
always #5 clk = ~clk;

initial begin

    clk = 1'b0;
    reset = 1'b1;
    packet_valid = 1'b0;
    suspicious = 1'b0;
    malformed = 1'b0;

    // -------------------------------------------------------------------------
    // RESET
    // -------------------------------------------------------------------------

    #20;
    reset = 1'b0;

    // -------------------------------------------------------------------------
    // NORMAL PACKET
    // -------------------------------------------------------------------------

    suspicious = 1'b0;
    malformed = 1'b0;
    packet_valid = 1'b1;
    #10;
    packet_valid = 1'b0;
    #10;

    // -------------------------------------------------------------------------
    // SUSPICIOUS PACKET
    // -------------------------------------------------------------------------

    suspicious = 1'b1;
    malformed = 1'b0;
    packet_valid = 1'b1;
    #10;
    packet_valid = 1'b0;
    #10;

    // -------------------------------------------------------------------------
    // MALFORMED PACKET
    // -------------------------------------------------------------------------

    suspicious = 1'b0;
    malformed = 1'b1;
    packet_valid = 1'b1;
    #10;
    packet_valid = 1'b0;
    #10;

    // -------------------------------------------------------------------------
    // FILL SUSPICIOUS COUNTER TO THRESHOLD
    //
    // One suspicious packet has already been counted.
    // Send 19 more so the total reaches 20.
    // -------------------------------------------------------------------------

    suspicious = 1'b1;
    malformed = 1'b0;

    for (i = 0; i < 19; i = i + 1) begin
        packet_valid = 1'b1;
        #10;
        packet_valid = 1'b0;
        #10;
    end

    // -------------------------------------------------------------------------
    // SUSPICIOUS PACKET BEYOND THRESHOLD
    //
    // This packet should be dropped.
    // -------------------------------------------------------------------------

    packet_valid = 1'b1;
    #10;
    packet_valid = 1'b0;
    #10;

    suspicious = 1'b0;

    // -------------------------------------------------------------------------
    // FINAL RESULTS
    // -------------------------------------------------------------------------

    $display("----------------------------------------");
    $display("Traffic Manager Test Results");
    $display("----------------------------------------");
    $display("Normal Count      = %d", normal_count);
    $display("Suspicious Count  = %d", suspicious_count);
    $display("Dropped Count     = %d", dropped_count);

    if (normal_count == 8'd1)
        $display("PASS: Normal packet count correct");
    else
        $display("FAIL: Normal packet count incorrect");

    if (suspicious_count == 8'd20)
        $display("PASS: Suspicious threshold reached correctly");
    else
        $display("FAIL: Suspicious threshold incorrect");

    if (dropped_count == 8'd2)
        $display("PASS: Dropped packet count correct");
    else
        $display("FAIL: Dropped packet count incorrect");

    $display("----------------------------------------");
    $display("Traffic manager tests complete");
    $display("----------------------------------------");

    $finish;

end

endmodule
