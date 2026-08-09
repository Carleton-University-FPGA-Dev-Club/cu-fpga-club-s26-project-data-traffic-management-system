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
wire malformed; // added category for packet inspection 2026-08-07

packet_inspector uut (
    .clk(clk),
    .packet_data(packet_data),
    .packet_valid(packet_valid),
    .suspicious(suspicious),
    .malformed(malformed)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    packet_valid = 0;
    packet_data = 16'h0000;

    #10;
    packet_valid = 1;

    packet_data = 16'hA123; // should be suspicious
    #10;
    if (suspicious && !malformed)
        $display("PASS: Header A detected as suspicious");
    else
        $display("FAIL: Header A should be suspicious");
        
    packet_data = 16'hC123; // should be suspicious
    #10;
    if (suspicious && !malformed)
        $display("PASS: Header C detected as suspicious");
    else
        $display("FAIL: Header C should be suspicious");
        
    packet_data = 16'hF134; // should be malformed
    #10;
    if (!suspicious && malformed)
        $display("PASS: Header F detected as malformed");
    else
        $display("FAIL: Header F should be malformed");

    packet_data = 16'hB123; // should be normal
    #10;
    if (!suspicious && !malformed)
        $display("PASS: Header B detected as normal");
    else
        $display("FAIL: Header B should be normal");

    packet_data = 16'hA999; // should be suspicious
    #10;
    
    if (suspicious && !malformed)
        $display("PASS: Header A detected as suspicious");
    else
        $display("FAIL: Header A should be suspicious");

    $finish;
end

endmodule
