`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 04:55:47 PM
// Design Name: 
// Module Name: packet_inspector
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


module packet_inspector(
    input wire clk,
    input wire [15:0] packet_data,
    input wire packet_valid,
    output reg suspicious
);

always @(posedge clk) begin
    if(packet_valid) begin
        if(packet_data[15:12] == 4'hA)
            suspicious <= 1;
        else
            suspicious <= 0;
    end
end

endmodule
