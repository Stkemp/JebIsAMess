`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2018 03:14:18 PM
// Design Name: 
// Module Name: Time_Counter
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


module Time_Counter(
    input clk,
    input CE,
    input R,
    output [4:0] Q
    );
    
    wire [4:0] D;
    assign D[4] = Q[4]^(CE&(&Q[3:0]));
    assign D[3] = Q[3]^(CE&(&Q[2:0]));
    assign D[2] = Q[2]^(CE&(&Q[1:0]));
    assign D[1] = Q[1]^(CE&(&Q[0]));
    assign D[0] = Q[0]^CE;
    
    FDRE #(.INIT(1'b0)) FF4_0[4:0] (.C({5{clk}}), .R({5{R}}), .CE({5{1'b1}}), .D(D[4:0]), .Q(Q[4:0]));
    
endmodule
