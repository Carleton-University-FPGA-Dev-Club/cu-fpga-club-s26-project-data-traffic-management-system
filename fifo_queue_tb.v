`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Olivia Fullerton
// 
// Create Date: 07/17/2026 03:11:13 PM
// Design Name: FIFO Queue (Testbench)
// Module Name: fifo_queue_tb
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


module fifo_queue_tb;

    reg clk;
    reg reset;
    
    reg write_enable;
    reg read_enable;
    reg [15:0] data_in;
    
    wire [15:0] data_out;
    wire full;
    wire empty;
    
    fifo_queue uut (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .data_in(data_in),
        .read_enable(read_enable),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );
    
    always #5 clk = ~clk;
    
    initial begin
    
        clk = 0;
        reset = 1;
        
        write_enable = 0;
        read_enable = 0;
        data_in = 16'h0000;
        
        // Test reset
        #20;
        reset = 0;
        if (empty)
            $display("PASS: FIFO empty after reset");
        else
            $display("FAIL: FIFO should be empty");
            
        // Test insert 1 packet
        data_in = 16'hA123;
        write_enable = 1;
        #10;
        write_enable = 0;
        if (!empty)
            $display("PASS: FIFO contains packet after write");
        else
            $display("FAIL: FIFO still empty");
        
        // Test remove 1 packet
        read_enable = 1;
        #10;
        read_enable = 0;
        if (data_out == 16'hA123)
            $display("PASS: Correct packet read");
        else
            $display("FAIL: Wrong packet read");
        if (empty)
            $display("PASS: FIFO empty after read");
        else
            $display("FAIL: FIFO should be empty");
        
        // Test FIFO order
        write_enable = 1;
        data_in = 16'h1111;
        #10;
        data_in = 16'h2222;
        #10;
        data_in = 16'h3333;
        #10;
        write_enable = 0;

        read_enable = 1; // read packets in order
        #10;
        if (data_out == 16'h1111)
            $display("PASS: FIFO order packet 1");
        else
            $display("FAIL: FIFO order packet 1");
        #10;
        if (data_out == 16'h2222)
            $display("PASS: FIFO order packet 2");
        else
            $display("FAIL: FIFO order packet 2");
        #10;
        if (data_out == 16'h3333)
            $display("PASS: FIFO order packet 3");
        else
            $display("FAIL: FIFO order packet 3");
        read_enable = 0;
        
        // Test full queue
        write_enable = 1; // add packets to max capacity
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
            $display("PASS: FIFO is detected as full");
        else
            $display("FAIL: FIFO should be detected as full");
        
        // Test adding to full queue
        data_in = 16'hFFFF;
        write_enable = 1;
        #10;
        write_enable = 0;
        if (full)
            $display("PASS: Overflow prevented");
        else
            $display("FAIL: FIFO overflow protection failed");
            
        // Test empty queue
        read_enable = 1;
        repeat(8)
            #10;
        read_enable = 0;
        if (empty)
            $display("PASS: FIFO is detected as empty");
        else
            $display("FAIL: FIFO should be detected as empty");
        
        #20
        $display("Tests complete");
        $finish;
    end
endmodule
