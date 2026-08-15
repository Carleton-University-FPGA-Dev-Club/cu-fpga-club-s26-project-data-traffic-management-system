`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Design Name: FPGA Traffic Management System
// Module Name: traffic_manager
// Project Name: Data Traffic Management System
//
// Description:
// Processes classified packets and maintains counters for normal,
// suspicious, and dropped traffic.
//
// Traffic management rules:
//   - Malformed packets are dropped immediately.
//   - Suspicious packets are counted until the threshold is reached.
//   - Suspicious packets beyond the threshold are dropped.
//   - All remaining packets are counted as normal traffic.
//////////////////////////////////////////////////////////////////////////////////

module traffic_manager(
    input wire clk,
    input wire reset,
    input wire packet_valid,
    input wire suspicious,
    input wire malformed,

    output reg [7:0] normal_count,
    output reg [7:0] suspicious_count,
    output reg [7:0] dropped_count
);

// Maximum number of suspicious packets accepted before dropping
localparam [7:0] SUSPICIOUS_THRESHOLD = 8'd20;

always @(posedge clk) begin
    if (reset) begin
        normal_count <= 0;
        suspicious_count <= 0;
        dropped_count <= 0;
    end
    else if (packet_valid) begin

        // Malformed packets are always dropped
        if (malformed) begin
            dropped_count <= dropped_count + 1;
        end

        // Suspicious packets are accepted until the threshold is reached
        else if (suspicious) begin
            if (suspicious_count >= SUSPICIOUS_THRESHOLD)
                dropped_count <= dropped_count + 1;
            else
                suspicious_count <= suspicious_count + 1;
        end

        // All other valid packets are normal traffic
        else begin
            normal_count <= normal_count + 1;
        end
    end
end

endmodule
