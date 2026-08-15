`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Design Name: FPGA Traffic Management System
// Module Name: packet_inspector_tb
// Project Name: Data Traffic Management System
// Target Device: Digilent Zybo Z7-20
// Tool Version: Vivado 2025.2
//
// Description:
// Testbench for the packet inspector.
//
// Verifies:
//   - Reset behavior
//   - Header A is classified as suspicious
//   - Header C is classified as suspicious
//   - Header F is classified as malformed
//   - Header B is classified as normal
//
// Dependencies:
// packet_inspector.v
//
// Revision:
// Revision 1.00 - Final integrated project version
//////////////////////////////////////////////////////////////////////////////////

module packet_inspector_tb;

reg clk;
reg reset;
reg [15:0] packet_data;
reg packet_valid;

wire suspicious;
wire malformed;

packet_inspector uut (
    .clk(clk),
    .reset(reset),
    .packet_data(packet_data),
    .packet_valid(packet_valid),
    .suspicious(suspicious),
    .malformed(malformed)
);

// 100 MHz simulation clock.
always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    reset = 1'b1;
    packet_valid = 1'b0;
    packet_data = 16'h0000;

    // Reset
    #20;
    reset = 1'b0;

    if (!suspicious && !malformed)
        $display("PASS: Inspector outputs cleared after reset");
    else
        $display("FAIL: Inspector outputs not cleared after reset");

    packet_valid = 1'b1;

    // Header A -> suspicious
    packet_data = 16'hA123;
    #10;

    if (suspicious && !malformed)
        $display("PASS: Header A classified as suspicious");
    else
        $display("FAIL: Header A classification incorrect");

    // Header C -> suspicious
    packet_data = 16'hC123;
    #10;

    if (suspicious && !malformed)
        $display("PASS: Header C classified as suspicious");
    else
        $display("FAIL: Header C classification incorrect");

    // Header F -> malformed
    packet_data = 16'hF134;
    #10;

    if (!suspicious && malformed)
        $display("PASS: Header F classified as malformed");
    else
        $display("FAIL: Header F classification incorrect");

    // Header B -> normal
    packet_data = 16'hB123;
    #10;

    if (!suspicious && !malformed)
        $display("PASS: Header B classified as normal");
    else
        $display("FAIL: Header B classification incorrect");

    $display("----------------------------------------");
    $display("Packet inspector tests complete");
    $display("----------------------------------------");

    $finish;
end

endmodule
