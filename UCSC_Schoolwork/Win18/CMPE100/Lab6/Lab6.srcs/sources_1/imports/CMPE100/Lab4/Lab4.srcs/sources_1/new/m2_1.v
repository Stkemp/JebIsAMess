`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2018 04:02:41 PM
// Design Name: 
// Module Name: m2_1
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


module m2_1(
    input in0,
    input in1,
    input sel,
    output o
    );
    
    assign o = in0&~sel | in1&sel;
    
endmodule
