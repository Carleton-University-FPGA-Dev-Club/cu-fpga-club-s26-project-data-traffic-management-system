`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Create Date: 06/03/2026 04:55:47 PM
// Design Name: FPGA Traffic Management System
// Module Name: packet_inspector
// Project Name: Data Traffic Management System
//
// Description:
// Examines the header of each valid 16-bit packet and classifies the
// packet as suspicious, malformed, or normal.
//
// Packet classification:
//   Header A -> Suspicious
//   Header C -> Suspicious
//   Header F -> Malformed
//   Other    -> Normal
//////////////////////////////////////////////////////////////////////////////////

module packet_inspector(
    input wire clk,
    input wire [15:0] packet_data,
    input wire packet_valid,
    output reg suspicious,
    output reg malformed
);

always @(posedge clk) begin
    if (packet_valid) begin
        suspicious <= 0;
        malformed <= 0;

        case (packet_data[15:12])

            // Suspicious packet headers
            4'hA: begin
                suspicious <= 1;
            end

            4'hC: begin
                suspicious <= 1;
            end

            // Malformed packet header
            4'hF: begin
                malformed <= 1;
            end

            // All other packet headers are normal
            default: begin
                suspicious <= 0;
                malformed <= 0;
            end

        endcase
    end
end

endmodule
