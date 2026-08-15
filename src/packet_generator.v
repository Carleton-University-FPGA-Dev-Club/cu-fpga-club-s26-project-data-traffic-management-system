`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Leen Naser
//
// Create Date: 06/03/2026 03:47:15 PM
// Design Name: FPGA Traffic Management System
// Module Name: packet_generator
// Project Name: Data Traffic Management System
//
// Description:
// Generates 16-bit packets for the traffic management system.
// Packet headers alternate between suspicious (A) and normal (B)
// traffic so both classifications can be demonstrated.
//////////////////////////////////////////////////////////////////////////////////

module packet_generator(
    input wire clk,
    input wire reset,
    output reg [15:0] packet_data,
    output reg packet_valid
);

reg [7:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        packet_data <= 16'h0000;
        packet_valid <= 0;
    end
    else begin
        counter <= counter + 1;

        // Alternate between suspicious and normal packet headers
        if (counter[0] == 0)
            packet_data <= {4'hA, counter};
        else
            packet_data <= {4'hB, counter};

        packet_valid <= 1;
    end
end

endmodule
