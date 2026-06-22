`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 03:47:15 PM
// Design Name: 
// Module Name: packet_generator
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


module packet_generator(
    input wire clk,
    input wire reset,
    output reg [15:0] packet_data,
    output reg packet_valid
);

reg [7:0] counter = 0;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        packet_data <= 0;
        packet_valid <= 0;
    end 
    else begin
        counter <= counter + 1;
        
        if (counter[0] == 0)
            packet_data <= {4'hA, counter[3:0], counter[7:4], 4'hF}; // suspicious
        else
            packet_data <= {4'hB, counter[3:0], counter[7:4], 4'hF}; // normal
        packet_valid <= 1;
    end
end

endmodule