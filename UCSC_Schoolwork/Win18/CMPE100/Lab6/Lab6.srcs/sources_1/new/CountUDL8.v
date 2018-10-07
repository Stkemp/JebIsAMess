`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2018 02:14:51 PM
// Design Name: 
// Module Name: CountUDL8
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


module CountUDL8(
    input clk,
    input up,
    input dw,
    input ld,
    input [7:0] Din,
    output [7:0] Q,
    output UTC,
    output DTC
    );
    
    wire[1:0] utc, dtc;
    
    CountUD4L counter0(clk, up, dw, ld, 1'b0, Din[3:0], Q[3:0], utc[0], dtc[0]);
    CountUD4L counter1(clk, up&utc[0], dw&dtc[0], ld, 1'b0, Din[7:4], Q[7:4], utc[1], dtc[1]);
    
    assign UTC = &utc;
    assign DTC = &dtc;
    
endmodule
