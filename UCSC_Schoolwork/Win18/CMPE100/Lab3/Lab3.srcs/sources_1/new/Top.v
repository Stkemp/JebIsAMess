`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2018 02:50:43 PM
// Design Name: 
// Module Name: Top
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


module Top(
    input [7:0] sw,
    input clkin,
    input btnR,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output dig_sel
    );
    
    wire na;
    wire [7:0]pout;
    wire [6:0]cupper, clower;
    
    Multiplier Mult (sw[7:4], sw[3:0], pout);
    hex7seg lower(pout[3:0],clower);
    hex7seg upper(pout[7:4],cupper);
    m2_1x8 SegMux({1'b0, clower}, {1'b0, cupper}, dig_sel, 1'b1, {na, seg});
    lab3_digsel myDigSel (clkin, btnR, dig_sel);
    
    assign an[0] = dig_sel;
    assign an[1] = ~dig_sel;
    assign an[2] = 1'b1;
    assign an[3] = 1'b1;
    assign dp = 1'b1;
    
endmodule
