`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2018 03:14:07 PM
// Design Name: 
// Module Name: MultiplierStage
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


module MultiplierStage(
    input [3:0] m,
    input [3:0] pin,
    input q,
    output [4:0]pout
    );
    
    wire c0, c1, c2;
    
    ANDFullAdder Adder1 (q, m[0], pin[0], 1'b0, c0, pout[0]);
    ANDFullAdder Adder2 (q, m[1], pin[1], c0, c1, pout[1]);
    ANDFullAdder Adder3 (q, m[2], pin[2], c1, c2, pout[2]);
    ANDFullAdder Adder4 (q, m[3], pin[3], c2, pout[4], pout[3]);
    
endmodule
