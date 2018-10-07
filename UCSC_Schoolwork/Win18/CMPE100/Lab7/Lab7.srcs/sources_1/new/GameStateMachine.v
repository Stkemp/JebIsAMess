`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2018 02:56:54 PM
// Design Name: 
// Module Name: GameStateMachine
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


module GameStateMachine(
    input clk,
    input Collision,
    input FourSec,
    input GameStart,
    input Win,
    output MovePieces,
    output MoveSkiier,
    output GameReset,
    output SCcountU,
    output SCcountD,
    output FlashSkiier,
    output FlashBorder,
    output GateTop,
    output RCounter
    );
    wire [4:0] Q, D;
    
    FDRE #(.INIT(1'b1)) Q0_FF (.C(clk), .CE(1'b1), .D(D[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) Q1234_FF[4:1] (.C({4{clk}}), .CE({4{1'b1}}), .D(D[4:1]), .Q(Q[4:1]));
    
    assign D[0] = Q[0] & ~GameStart;
    assign D[1] = Q[0]&GameStart | Q[1]&~FourSec | Q[3]&GameStart | Q[4]&GameStart;
    assign D[2] = Q[1]&FourSec | Q[2]&~Collision&~Win;
    assign D[3] = Q[2]&Win | Q[3]&~GameStart;
    assign D[4] = Q[2]&~Win&Collision | Q[4]&~GameStart;
    
    assign MovePieces = Q[2] | Q[3];
    assign MoveSkiier = Q[2];
    assign GameReset = Q[0] | Q[3]&GameStart | Q[4]&GameStart;
    assign SCcountU = Q[2]&Win;
    assign SCcountD = Q[2]&~Win&Collision;
    assign FlashSkiier = Q[1] | Q[3] | Q[4];
    assign FlashBorder = Q[3];
    assign GateTop = Q[2];
    assign RCounter = Q[0]&GameStart | Q[3]&GameStart | Q[4]&GameStart;
        
endmodule
