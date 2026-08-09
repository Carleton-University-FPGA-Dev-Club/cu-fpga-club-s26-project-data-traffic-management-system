`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Olivia Fullerton
// 
// Create Date: 08/07/2026 09:49:38 PM
// Design Name: LED Controller (Testbench)
// Module Name: led_controller_tb
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

module led_controller_tb;

reg normal_check;
reg suspicious_check;
reg dropped_check;
reg fifo_full;
wire led0;
wire led1;
wire led2;
wire led3;

led_controller uut (
    .normal_check(normal_check),
    .suspicious_check(suspicious_check),
    .dropped_check(dropped_check),
    .fifo_full(fifo_full),
    .led0(led0),
    .led1(led1),
    .led2(led2),
    .led3(led3)
);

initial begin
    normal_check = 0;
    suspicious_check = 0;
    dropped_check = 0;
    fifo_full = 0;
    
    #10;
    
    // Test normal packet
    normal_check = 1;
    #10;
    if (led0 == 1 && led1 == 0 && led2 == 0 && led3 == 0)
        $display("PASS: LED0 registered normal packet");
    else
        $display("FAIL: LED0 did not register normal packet");
        
    // Test suspicious packet
    suspicious_check = 1;
    #10;
    if (led1 == 1)
        $display("PASS: LED1 registered suspicious packet");
    else
        $display("FAIL: LED1 did not register suspicious packet");
        
    // Test dropped packet
    dropped_check = 1;
    #10;
    if (led2 == 1)
        $display("PASS: LED2 registered dropped packet");
    else
        $display("FAIL: LED2 did not register dropped packet");
    
    // Test full FIFO queue
    fifo_full = 1;
    #10;
    if (led3 == 1)
        $display("PASS: LED3 registered FIFO is full");
    else
        $display("FAIL: LED3 did not register FIFO was full");
    
    $display("LED controller tests complete");
    
    $finish;
    
end

endmodule
