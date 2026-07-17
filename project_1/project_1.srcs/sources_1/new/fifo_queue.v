`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Olivia Fullerton
// 
// Create Date: 07/17/2026 01:41:50 PM
// Design Name: FIFO Queue
// Module Name: fifo_queue
// Project Name: Data Traffic Management System
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


module fifo_queue(
    input wire clk,
    input wire reset,
    
    // Entering packets/writing data to queue
    input wire write_enable,
    input wire [15:0] data_in,
    
    // Exiting packets/reading data from queue
    input wire read_enable,
    output reg [15:0] data_out,
    
    // Queue status signals
    output wire full,
    output wire empty
);
    
    // Queue
    reg [15:0] memory [0:7];
    
    // read/write pointers (end/start)
    reg [2:0] write_ptr;
    reg [2:0] read_ptr;
    
    // Count of items in queue
    reg [3:0] count;
    
    // Status signals
    assign empty = (count == 0);
    assign full = (count == 8);
    
    always @(posedge clk) begin
    
        if (reset) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            data_out <= 0;
        end
        
        else begin
            
            // Write/enter new packet
            if (write_enable && !full) begin
                memory[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
            end
            
            // Read/exit packet
            if (read_enable && !empty) begin
                data_out <= memory[read_ptr];
                read_ptr <= read_ptr + 1;
            end
            
            // Increment count
            case ({write_enable && !full, read_enable && !empty})
                // write only
                2'b10:
                    count <= count + 1;
                    
                // read only
                2'b01:
                    count <= count - 1;
                
                // read and write
                2'b11:
                    count <= count;
                // nothing happened
                default:
                    count <= count;
            endcase
        end
    end
endmodule
