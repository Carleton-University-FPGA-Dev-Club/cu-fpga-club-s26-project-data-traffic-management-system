`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 05:26:56 PM
// Design Name: 
// Module Name: traffic_manager
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


module traffic_manager(
    input wire clk,
    input wire reset,
    input wire packet_valid,
    input wire suspicious,
    output reg [7:0] normal_count,
    output reg [7:0] suspicious_count,
    output reg [7:0] dropped_count
);

always @(posedge clk) begin
    if (reset) begin
        normal_count <= 0;
        suspicious_count <= 0;
        dropped_count <= 0;
    end
    else if (packet_valid) begin
        if (suspicious) begin
            if (suspicious_count >= 20)
                dropped_count <= dropped_count + 1;
            else
                suspicious_count <= suspicious_count + 1;
        end
        else begin
            normal_count <= normal_count + 1;
        end
    end
end

endmodule
