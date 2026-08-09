`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Olivia Fullerton
// 
// Create Date: 08/07/2026 09:42:31 PM
// Design Name: LED Controller
// Module Name: led_controller
// Project Name: Data Traffic Management System
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Due to the fact that LEDs flashing on the clock cycle is too
// fast for the human eye to detect, LEDs will represent when the criteria for the 
// respective condition is initially met.
//////////////////////////////////////////////////////////////////////////////////

module led_controller(
    input wire normal_check,
    input wire suspicious_check,
    input wire dropped_check,
    input wire fifo_full,
    
    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3
    );
    
    // Normal packet processed
    assign led0 = normal_check;
    
    // Suspicious packet processed
    assign led1 = suspicious_check;
    
    // Dropped packet detected
    assign led2 = dropped_check;
    
    // Full queue detected
    assign led3 = fifo_full;
    
endmodule
