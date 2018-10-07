`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2018 02:43:52 PM
// Design Name: 
// Module Name: SkiStateMachine
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


module SkiStateMachine(
    input clk,
    input Switch,
    input Left,
    input Right,
    output ScntU,
    output ScntD
    );
    
    wire [1:0] D, Q;
    
    FDRE #(.INIT(1'b1)) Q0_FF (.C(clk), .CE(1'b1), .D(D[0]), .Q(Q[0])); // Right
    FDRE #(.INIT(1'b0)) Q1_FF (.C(clk), .CE(1'b1), .D(D[1]), .Q(Q[1])); // Left
    
    assign D[0] = Q[0]&~Switch&~Left | Q[1]&Switch&~Right | Q[1]&~Switch&Right | Q[0]&Switch&Left;
    assign D[1] = Q[1]&~Switch&~Right | Q[0]&Switch&~Left | Q[0]&~Switch&Left | Q[1]&Switch&Right;
    assign ScntU = Q[0];
    assign ScntD = Q[1];
    
    
    
endmodule
