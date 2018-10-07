`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2018 02:25:29 PM
// Design Name: 
// Module Name: m2_1x8
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


module m2_1x8(
    input [7:0] in0,
    input [7:0] in1,
    input sel,
    input e,
    output [7:0] o
    );
    
    wire [7:0] to_out, sel8bit, e8bit;
    
    assign sel8bit = {sel,sel,sel,sel,sel,sel,sel,sel};
    assign e8bit = {e,e,e,e,e,e,e,e};
    
    assign to_out = in0&~sel8bit | in1&sel8bit;
    assign o = to_out & e8bit;
endmodule
