`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 04:05:55 PM
// Design Name: 
// Module Name: packet_generator_tb
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


module packet_generator_tb;

reg clk;
reg reset;
wire [15:0] packet_data;
wire packet_valid;

packet_generator uut (
    .clk(clk),
    .reset(reset),
    .packet_data(packet_data),
    .packet_valid(packet_valid)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;

    #20;
    reset = 0;

    #200;
    $finish;
end

endmodule
