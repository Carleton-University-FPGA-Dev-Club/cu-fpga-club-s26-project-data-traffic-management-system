`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Create Date: 07/17/2026 01:41:50 PM
// Design Name: FPGA Traffic Management System
// Module Name: fifo_queue
// Project Name: Data Traffic Management System
//
// Description:
// Implements an 8-entry FIFO queue for buffering 16-bit packets.
// The queue maintains independent read and write pointers and provides
// full, empty, and data-valid status signals.
//
// The FIFO prevents writes when full and reads when empty.
//////////////////////////////////////////////////////////////////////////////////

module fifo_queue(
    input wire clk,
    input wire reset,

    input wire write_enable,
    input wire [15:0] data_in,

    input wire read_enable,
    output reg [15:0] data_out,
    output reg data_valid,

    output wire full,
    output wire empty
);

reg [15:0] memory [0:7];

reg [2:0] write_ptr;
reg [2:0] read_ptr;
reg [3:0] count;

assign empty = (count == 0);
assign full  = (count == 8);

always @(posedge clk) begin
    if (reset) begin
        write_ptr  <= 0;
        read_ptr   <= 0;
        count      <= 0;
        data_out   <= 0;
        data_valid <= 0;
    end
    else begin
        data_valid <= 0;

        // Write packet when space is available
        if (write_enable && !full) begin
            memory[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
        end

        // Read packet when data is available
        if (read_enable && !empty) begin
            data_out <= memory[read_ptr];
            read_ptr <= read_ptr + 1;
            data_valid <= 1;
        end

        // Update number of packets stored
        case ({write_enable && !full, read_enable && !empty})
            2'b10: count <= count + 1;
            2'b01: count <= count - 1;
            2'b11: count <= count;
            default: count <= count;
        endcase
    end
end

endmodule
