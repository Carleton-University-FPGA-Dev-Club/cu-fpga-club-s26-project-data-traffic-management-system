`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Create Date: 06/03/2026 04:05:55 PM
// Design Name: FPGA Traffic Management System
// Module Name: packet_generator_tb
// Project Name: Data Traffic Management System
// Target Device: Digilent Zybo Z7-20
// Tool Version: Vivado 2025.2
//
// Description:
// Testbench for the packet generator.
//
// Verifies that:
//   - packet_valid is asserted after reset.
//   - Suspicious packets with header 4'hA are generated.
//   - Normal packets with header 4'hB are generated.
//
// Dependencies:
// packet_generator.v
//
// Revision:
// Revision 1.00 - Final integrated project version
//////////////////////////////////////////////////////////////////////////////////

module packet_generator_tb;

reg clk;
reg reset;

wire [15:0] packet_data;
wire packet_valid;

reg saw_suspicious;
reg saw_normal;

packet_generator uut (
    .clk(clk),
    .reset(reset),
    .packet_data(packet_data),
    .packet_valid(packet_valid)
);

// 100 MHz simulation clock.
// The physical board clock is constrained separately in the XDC file.
always #5 clk = ~clk;

always @(posedge clk) begin
    if (reset) begin
        saw_suspicious <= 1'b0;
        saw_normal     <= 1'b0;
    end
    else if (packet_valid) begin
        if (packet_data[15:12] == 4'hA)
            saw_suspicious <= 1'b1;

        if (packet_data[15:12] == 4'hB)
            saw_normal <= 1'b1;
    end
end

initial begin
    clk   = 1'b0;
    reset = 1'b1;

    #20;
    reset = 1'b0;

    #200;

    if (packet_valid)
        $display("PASS: packet_valid asserted");
    else
        $display("FAIL: packet_valid was not asserted");

    if (saw_suspicious)
        $display("PASS: Suspicious packets generated");
    else
        $display("FAIL: No suspicious packets generated");

    if (saw_normal)
        $display("PASS: Normal packets generated");
    else
        $display("FAIL: No normal packets generated");

    if (saw_suspicious && saw_normal)
        $display("PASS: Packet generator test completed successfully");
    else
        $display("FAIL: Packet generator test failed");

    $finish;
end

endmodule
