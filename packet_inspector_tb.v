`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 04:59:48 PM
// Design Name: 
// Module Name: packet_inspector_tb
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


module packet_inspector_tb;

reg clk;
reg [15:0] packet_data;
reg packet_valid;
wire suspicious;

packet_inspector uut (
    .clk(clk),
    .packet_data(packet_data),
    .packet_valid(packet_valid),
    .suspicious(suspicious)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    packet_valid = 0;
    packet_data = 16'h0000;

    #10;
    packet_valid = 1;

    packet_data = 16'hA123; // should be suspicious
    #20;

    packet_data = 16'hB123; // should NOT be suspicious
    #20;

    packet_data = 16'hA999; // should be suspicious
    #20;

    $finish;
end

endmodule
