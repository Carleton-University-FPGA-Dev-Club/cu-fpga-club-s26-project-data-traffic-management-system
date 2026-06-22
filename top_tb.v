`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 06:37:14 PM
// Design Name: 
// Module Name: top_tb
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
    .suspicious_count(suspicious_count)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;

    #20;
    reset = 0;

    #500;
    $finish;
end

endmodule
