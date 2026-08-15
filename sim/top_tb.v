`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Design Name: FPGA Traffic Management System
// Module Name: top_tb
// Project Name: Data Traffic Management System
// Target Device: Digilent Zybo Z7-20
// Tool Version: Vivado 2025.2
//
// Description:
// System-level testbench for the complete FPGA packet-processing pipeline.
//
// Pipeline:
//   Packet Generator -> FIFO Queue -> Packet Inspector -> Traffic Manager
//
// Verifies that the integrated system:
//   - Resets correctly
//   - Processes generated packets
//   - Produces normal traffic
//   - Produces suspicious traffic
//   - Produces dropped traffic after the suspicious threshold is reached
//
// Dependencies:
// top.v
//
// Revision:
// Revision 1.00 - Final integrated project version
//////////////////////////////////////////////////////////////////////////////////

module top_tb;

reg clk;
reg reset;

wire [7:0] normal_count;
wire [7:0] suspicious_count;
wire [7:0] dropped_count;

top uut (
    .clk(clk),
    .reset(reset),
    .normal_count(normal_count),
    .suspicious_count(suspicious_count),
    .dropped_count(dropped_count)
);

// 100 MHz simulation clock.
// The physical Zybo Z7-20 clock is constrained separately in the XDC file.
always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    reset = 1'b1;

    // Hold reset for two clock cycles.
    #20;
    reset = 1'b0;

    if ((normal_count == 8'd0) &&
        (suspicious_count == 8'd0) &&
        (dropped_count == 8'd0))
        $display("PASS: System counters cleared after reset");
    else
        $display("FAIL: System counters not cleared after reset");

    // Allow the complete processing pipeline to run.
    #1000;

    $display("----------------------------------------");
    $display("System-Level Results");
    $display("----------------------------------------");
    $display("Normal Count      = %d", normal_count);
    $display("Suspicious Count  = %d", suspicious_count);
    $display("Dropped Count     = %d", dropped_count);

    if (normal_count > 0)
        $display("PASS: Normal traffic processed");
    else
        $display("FAIL: No normal traffic processed");

    if (suspicious_count > 0)
        $display("PASS: Suspicious traffic processed");
    else
        $display("FAIL: No suspicious traffic processed");

    if (dropped_count > 0)
        $display("PASS: Dropped traffic detected");
    else
        $display("FAIL: No dropped traffic detected");

    if (suspicious_count == 8'd20)
        $display("PASS: Suspicious packet threshold reached");
    else
        $display("FAIL: Suspicious packet threshold incorrect");

    $display("----------------------------------------");
    $display("System-level tests complete");
    $display("----------------------------------------");

    $finish;
end

endmodule
