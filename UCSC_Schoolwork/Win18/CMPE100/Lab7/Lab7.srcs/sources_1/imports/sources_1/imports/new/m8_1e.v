`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2018 02:25:29 PM
// Design Name: 
// Module Name: m8_1e
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


module m8_1e(
    input [7:0] in,
    input [2:0] sel,
    input e,
    output o
    );
    
    wire to_out;
        wire [7:0] r;
        
        assign r[0] = in[0]&~sel[2]&~sel[1]&~sel[0];
        assign r[1] = in[1]&~sel[2]&~sel[1]&sel[0];
        assign r[2] = in[2]&~sel[2]&sel[1]&~sel[0];
        assign r[3] = in[3]&~sel[2]&sel[1]&sel[0];
        assign r[4] = in[4]&sel[2]&~sel[1]&~sel[0];
        assign r[5] = in[5]&sel[2]&~sel[1]&sel[0];
        assign r[6] = in[6]&sel[2]&sel[1]&~sel[0];
        assign r[7] = in[7]&sel[2]&sel[1]&sel[0];
        
        assign to_out = |r;
        assign o = to_out&e;
endmodule
