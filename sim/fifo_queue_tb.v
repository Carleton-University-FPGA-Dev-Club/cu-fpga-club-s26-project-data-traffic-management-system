`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineers: Leen Naser, Olivia Fullerton
//
// Create Date: 07/17/2026 03:11:13 PM
// Design Name: FPGA Traffic Management System
// Module Name: fifo_queue_tb
// Project Name: Data Traffic Management System
// Target Device: Digilent Zybo Z7-20
// Tool Version: Vivado 2025.2
//
// Description:
// Testbench for the FIFO queue.
//
// Verifies:
//   - Reset behavior
//   - Packet writes and reads
//   - FIFO ordering
//   - Full and empty states
//   - Overflow protection
//   - data_valid behavior
//
// Dependencies:
// fifo_queue.v
//
// Revision:
// Revision 1.00 - Final integrated project version
//////////////////////////////////////////////////////////////////////////////////

module fifo_queue_tb;

reg clk;
reg reset;

reg write_enable;
reg read_enable;
reg [15:0] data_in;

wire [15:0] data_out;
wire data_valid;
wire full;
wire empty;

fifo_queue uut (
    .clk(clk),
    .reset(reset),
    .write_enable(write_enable),
    .data_in(data_in),
    .read_enable(read_enable),
    .data_out(data_out),
    .data_valid(data_valid),
    .full(full),
    .empty(empty)
);

// 100 MHz simulation clock.
always #5 clk = ~clk;

initial begin

    clk = 0;
    reset = 1;
    write_enable = 0;
    read_enable = 0;
    data_in = 16'h0000;

    // -------------------------------------------------------------------------
    // RESET TEST
    // -------------------------------------------------------------------------

    #20;
    reset = 0;

    if (empty)
        $display("PASS: FIFO empty after reset");
    else
        $display("FAIL: FIFO should be empty after reset");

    if (!data_valid)
        $display("PASS: data_valid low after reset");
    else
        $display("FAIL: data_valid should be low after reset");


    // -------------------------------------------------------------------------
    // SINGLE WRITE TEST
    // -------------------------------------------------------------------------

    data_in = 16'hA123;
    write_enable = 1;
    #10;
    write_enable = 0;

    if (!empty)
        $display("PASS: FIFO contains packet after write");
    else
        $display("FAIL: FIFO still empty after write");

    if (!data_valid)
        $display("PASS: data_valid low before read");
    else
        $display("FAIL: data_valid should be low before read");


    // -------------------------------------------------------------------------
    // SINGLE READ TEST
    // -------------------------------------------------------------------------

    read_enable = 1;
    #10;

    if (data_out == 16'hA123)
        $display("PASS: Correct packet read");
    else
        $display("FAIL: Incorrect packet read");

    if (data_valid)
        $display("PASS: data_valid high during valid read");
    else
        $display("FAIL: data_valid should be high during valid read");

    read_enable = 0;
    #10;

    if (empty)
        $display("PASS: FIFO empty after read");
    else
        $display("FAIL: FIFO should be empty after read");

    if (!data_valid)
        $display("PASS: data_valid returned low after read");
    else
        $display("FAIL: data_valid should return low after read");


    // -------------------------------------------------------------------------
    // FIFO ORDER TEST
    // -------------------------------------------------------------------------

    write_enable = 1;

    data_in = 16'h1111;
    #10;

    data_in = 16'h2222;
    #10;

    data_in = 16'h3333;
    #10;

    write_enable = 0;

    read_enable = 1;

    #10;
    if ((data_out == 16'h1111) && data_valid)
        $display("PASS: FIFO order packet 1");
    else
        $display("FAIL: FIFO order packet 1");

    #10;
    if ((data_out == 16'h2222) && data_valid)
        $display("PASS: FIFO order packet 2");
    else
        $display("FAIL: FIFO order packet 2");

    #10;
    if ((data_out == 16'h3333) && data_valid)
        $display("PASS: FIFO order packet 3");
    else
        $display("FAIL: FIFO order packet 3");

    read_enable = 0;
    #10;


    // -------------------------------------------------------------------------
    // FULL FIFO TEST
    // -------------------------------------------------------------------------

    write_enable = 1;

    data_in = 16'h0001;
    #10;
    data_in = 16'h0002;
    #10;
    data_in = 16'h0003;
    #10;
    data_in = 16'h0004;
    #10;
    data_in = 16'h0005;
    #10;
    data_in = 16'h0006;
    #10;
    data_in = 16'h0007;
    #10;
    data_in = 16'h0008;
    #10;

    write_enable = 0;

    if (full)
        $display("PASS: FIFO detected as full");
    else
        $display("FAIL: FIFO should be full");


    // -------------------------------------------------------------------------
    // OVERFLOW PROTECTION TEST
    // -------------------------------------------------------------------------

    data_in = 16'hFFFF;
    write_enable = 1;
    #10;
    write_enable = 0;

    if (full)
        $display("PASS: FIFO overflow prevented");
    else
        $display("FAIL: FIFO overflow protection failed");


    // -------------------------------------------------------------------------
    // EMPTY FIFO
    // -------------------------------------------------------------------------

    read_enable = 1;

    repeat (8)
        #10;

    read_enable = 0;
    #10;

    if (empty)
        $display("PASS: FIFO detected as empty");
    else
        $display("FAIL: FIFO should be empty");


    // -------------------------------------------------------------------------
    // EMPTY READ TEST
    // -------------------------------------------------------------------------

    read_enable = 1;
    #10;

    if (!data_valid)
        $display("PASS: data_valid remains low when reading empty FIFO");
    else
        $display("FAIL: data_valid should remain low when FIFO is empty");

    read_enable = 0;

    #20;

    $display("----------------------------------------");
    $display("FIFO queue tests complete");
    $display("----------------------------------------");

    $finish;

end

endmodule
