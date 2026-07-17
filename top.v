`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 05:41:21 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input wire clk,
    input wire reset,
    output wire [7:0] normal_count,
    output wire [7:0] suspicious_count,
    output wire [7:0] dropped_count
);

wire [15:0] packet_data;
wire packet_valid;
wire suspicious;

packet_generator gen (
    .clk(clk),
    .reset(reset),
    .packet_data(packet_data),
    .packet_valid(packet_valid)
);

packet_inspector inspect (
    .clk(clk),
    .packet_data(packet_data),
    .packet_valid(packet_valid),
    .suspicious(suspicious)
);

traffic_manager manager (
    .clk(clk),
    .reset(reset),
    .packet_valid(packet_valid),
    .suspicious(suspicious),
    .normal_count(normal_count),
    .suspicious_count(suspicious_count),
    .dropped_count(dropped_count)
);

endmodule
