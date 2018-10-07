`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2018 03:09:33 PM
// Design Name: 
// Module Name: Adder8
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


module Adder8(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] s,
    output cout
    );
    
    wire[6:0] cini;
    
    FullAdder Adder0 (a[0], b[0], cin, s[0], cini[0]);
    FullAdder Adder1 (a[1], b[1], cini[0], s[1], cini[1]);
    FullAdder Adder2 (a[2], b[2], cini[1], s[2], cini[2]);
    FullAdder Adder3 (a[3], b[3], cini[2], s[3], cini[3]);
    FullAdder Adder4 (a[4], b[4], cini[3], s[4], cini[4]);
    FullAdder Adder5 (a[5], b[5], cini[4], s[5], cini[5]);
    FullAdder Adder6 (a[6], b[6], cini[5], s[6], cini[6]);
    FullAdder Adder7 (a[7], b[7], cini[6], s[7], cout);
    
endmodule
