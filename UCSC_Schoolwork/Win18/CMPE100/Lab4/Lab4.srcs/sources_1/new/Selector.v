`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2018 02:23:18 PM
// Design Name: 
// Module Name: Selector
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


module Selector(
    input [3:0] sel,
    input [15:0] N,
    output [3:0] H
    );
    
    wire [1:0]s;
    assign s[1] = ~sel[0] & ~sel[1];
    assign s[0] = sel[3]&~sel[2]&~sel[1]&~sel[0] | ~sel[3]&~sel[2]&sel[1]&~sel[0];
    
    m4_1x4 myMux (N[3:0], N[7:4], N[11:8], N[15:12], s, 1'b1, H); 
    
endmodule
