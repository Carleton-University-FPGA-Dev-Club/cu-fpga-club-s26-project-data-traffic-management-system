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
    output reg suspicious,
    output reg malformed // added category for packet inspection 2026-08-07
);

always @(posedge clk) begin
    if (packet_valid) begin
    
        suspicious <= 0;
        malformed <= 0;
        
        case (packet_data[15:12])
        
            // Suspicious
            4'hA: begin
                suspicious <= 1;
            end
            4'hC: begin
                suspicious <= 1;
            end
            
            // Malformed
            4'hF: begin
                malformed <= 1;
            end
            
            // Normal
            default: begin
                suspicious <= 0;
                malformed <= 0;
            end
            
        endcase
    end
end

endmodule
