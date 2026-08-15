`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Create Date: 06/03/2026 03:47:15 PM
// Design Name: FPGA Traffic Management System
// Module Name: packet_generator
// Project Name: Data Traffic Management System
// Target Device: Digilent Zybo Z7-20
// Tool Version: Vivado 2025.2
//
// Description:
// Generates 16-bit test packets for the traffic management pipeline.
//
// Packets alternate between two header types:
//   4'hA - Suspicious packet
//   4'hB - Normal packet
//
// The remaining packet bits are derived from an internal counter so that
// successive packets contain changing payload data.
//
// packet_valid is asserted whenever a generated packet is available.
//
// Dependencies:
// None
//
// Revision:
// Revision 1.00 - Final integrated project version
//////////////////////////////////////////////////////////////////////////////////

module packet_generator(
    input  wire        clk,
    input  wire        reset,
    output reg  [15:0] packet_data,
    output reg         packet_valid
);

reg [7:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter      <= 8'd0;
        packet_data  <= 16'd0;
        packet_valid <= 1'b0;
    end
    else begin
        counter <= counter + 1'b1;

        // Alternate between suspicious and normal packet headers.
        if (counter[0] == 1'b0)
            packet_data <= {4'hA, counter[3:0], counter[7:4], 4'hF};
        else
            packet_data <= {4'hB, counter[3:0], counter[7:4], 4'hF};

        packet_valid <= 1'b1;
    end
end

endmodule
