`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2018 06:44:28 PM
// Design Name: 
// Module Name: counterUD16L
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


module counterUD16L(
    input clk,
    input [15:0] Din,
    input up,
    input dw,
    input r,
    input ld,
    output [15:0] Q,
    output UTC,
    output DTC
    );
    
    wire [3:0] iUTC, iDTC;
    
    CountUD4L count1(clk, up, dw, r, ld, Din[3:0], Q[3:0], iUTC[0], iDTC[0]);
    CountUD4L count2(clk, up&iUTC[0], dw&iDTC[0], r, ld, Din[7:4], Q[7:4], iUTC[1], iDTC[1]);
    CountUD4L count3(clk, up&(&iUTC[1:0]), dw&(&iDTC[1:0]), r, ld, Din[11:8], Q[11:8], iUTC[2], iDTC[2]);
    CountUD4L count4(clk, up&(&iUTC[2:0]), dw&(&iDTC[2:0]), r, ld, Din[15:12], Q[15:12], iUTC[3], iDTC[3]);
    
    assign UTC = &iUTC;
    assign DTC = &iDTC;
    
endmodule
