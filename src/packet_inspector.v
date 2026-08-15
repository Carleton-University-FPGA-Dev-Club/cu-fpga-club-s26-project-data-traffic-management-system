`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Create Date: 06/03/2026 04:55:47 PM
// Design Name: FPGA Traffic Management System
// Module Name: packet_inspector
// Project Name: Data Traffic Management System
// Target Device: Digilent Zybo Z7-20
// Tool Version: Vivado 2025.2
//
// Description:
// Inspects the upper 4-bit packet header and classifies each valid packet.
//
// Header classifications:
//   4'hA - Suspicious
//   4'hC - Suspicious
//   4'hF - Malformed
//   Other - Normal
//
// The suspicious and malformed outputs are registered and updated only when
// packet_valid is asserted.
//
// Dependencies:
// None
//
// Revision:
// Revision 1.00 - Final integrated project version
//////////////////////////////////////////////////////////////////////////////////

module packet_inspector(
    input  wire        clk,
    input  wire        reset,
    input  wire [15:0] packet_data,
    input  wire        packet_valid,
    output reg         suspicious,
    output reg         malformed
);

always @(posedge clk) begin
    if (reset) begin
        suspicious <= 1'b0;
        malformed  <= 1'b0;
    end
    else if (packet_valid) begin
        case (packet_data[15:12])

            // Suspicious packet headers
            4'hA,
            4'hC: begin
                suspicious <= 1'b1;
                malformed  <= 1'b0;
            end

            // Malformed packet header
            4'hF: begin
                suspicious <= 1'b0;
                malformed  <= 1'b1;
            end

            // Normal packet
            default: begin
                suspicious <= 1'b0;
                malformed  <= 1'b0;
            end

        endcase
    end
end

endmodule
