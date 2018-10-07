`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2018 02:05:48 PM
// Design Name: 
// Module Name: m4_1x4
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


module m4_1x4(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [1:0] sel,
    input e,
    output [3:0] o
    );
    
    wire [3:0] sel0x4, sel1x4, r0, r1, r2, r3, to_out, ex4;
    
    assign sel0x4 = {sel[0], sel[0], sel[0], sel[0]};
    assign sel1x4 = {sel[1], sel[1], sel[1], sel[1]};
    
    assign r0 = in0&~sel1x4&~sel0x4;
    assign r1 = in1&~sel1x4&sel0x4;
    assign r2 = in2&sel1x4&~sel0x4;
    assign r3 = in3&sel1x4&sel0x4;
    
    assign to_out = r0|r1|r2|r3;
    
    assign ex4 = {e,e,e,e};
    
    assign o = to_out & ex4;
    
endmodule
