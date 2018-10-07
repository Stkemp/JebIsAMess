`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2018 01:53:01 PM
// Design Name: 
// Module Name: hex7seg
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


module hex7seg(
    input [3:0] n,
    output [6:0] c
    );
    
    wire [7:0] A, B, C, D, E, F, G;
    assign A = {1'b0, n[0], n[0], 1'b0, 1'b0, ~n[0], 1'b0, n[0]};
    assign B = {1'b1, ~n[0], n[0], 1'b0, ~n[0], n[0], 1'b0, 1'b0};
    assign C = {1'b1, ~n[0], 1'b0, 1'b0, 1'b0, 1'b0, ~n[0], 1'b0};
    assign D = {n[0],1'b0,~n[0],n[0],n[0],~n[0],1'b0,n[0]};
    assign E = {1'b0,1'b0,1'b0,n[0],n[0],1'b1,n[0],n[0]};
    assign F = {1'b0,n[0],1'b0,1'b0,n[0],1'b0,1'b1,n[0]};
    assign G = {1'b0,~n[0],1'b0,1'b0,n[0],1'b0,1'b0,1'b1};
    
    m8_1e muxA (A, n[3:1], 1'b1, c[0]);
    m8_1e muxB (B, n[3:1], 1'b1, c[1]);
    m8_1e muxC (C, n[3:1], 1'b1, c[2]);
    m8_1e muxD (D, n[3:1], 1'b1, c[3]);
    m8_1e muxE (E, n[3:1], 1'b1, c[4]);
    m8_1e muxF (F, n[3:1], 1'b1, c[5]);
    m8_1e muxG (G, n[3:1], 1'b1, c[6]);
    
endmodule
