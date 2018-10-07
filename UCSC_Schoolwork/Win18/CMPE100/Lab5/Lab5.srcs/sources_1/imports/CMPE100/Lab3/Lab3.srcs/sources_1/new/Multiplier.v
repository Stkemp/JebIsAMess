`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2018 03:24:49 PM
// Design Name: 
// Module Name: Multiplier
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


module Multiplier(
    input [3:0] m,
    input [3:0] q,
    output [7:0] p
    );
    
    wire [4:0] w1, w2, w3, w4;
    
    MultiplierStage Stage1 (m, 4'b0000, q[0], w1);
    MultiplierStage Stage2 (m, w1[4:1], q[1], w2);
    MultiplierStage Stage3 (m, w2[4:1], q[2], w3);
    MultiplierStage Stage4 (m, w3[4:1], q[3], w4);
    
    assign p[0] = w1[0];
    assign p[1] = w2[0];
    assign p[2] = w3[0];
    assign p[7:3] = w4;
    
endmodule
