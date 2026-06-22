`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 05:36:27 PM
// Design Name: 
// Module Name: traffic_manager_tb
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


module traffic_manager_tb;

reg clk;
reg reset;
reg packet_valid;
reg suspicious;

wire [7:0] normal_count;
wire [7:0] suspicious_count;

traffic_manager uut (
    .clk(clk),
    .reset(reset),
    .packet_valid(packet_valid),
    .suspicious(suspicious),
    .normal_count(normal_count),
    .suspicious_count(suspicious_count)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    packet_valid = 0;
    suspicious = 0;

    #20;
    reset = 0;
    packet_valid = 1;

    suspicious = 0; #10; // normal
    suspicious = 1; #10; // suspicious
    suspicious = 1; #10; // suspicious
    suspicious = 0; #10; // normal

    $finish;
end

endmodule
