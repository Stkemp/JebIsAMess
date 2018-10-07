`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2018 03:14:18 PM
// Design Name: 
// Module Name: State_Machine
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


module State_Machine(
    input clk,
    input Go,
    input Ans,
    input correct,
    input Over,
    input FourSec,
    output ShowScore,
    output ShowArgs,
    output RTimer,
    output cntL,
    output cntR,
    output FlashL,
    output FlashR,
    output RunLFSR,
    output RScore
    );
    
    wire [5:0] D, Q;
    
    // FF inputs
    assign D[5] = Q[1]&~Over&FourSec | Q[5]&~Go;
    assign D[4] = Q[5]&Go | Q[4]&~Ans&~FourSec | Q[0]&Go;
    assign D[3] = Q[4]&Ans&correct&~FourSec | Q[3]&~FourSec;
    assign D[2] = Q[4]&FourSec | Q[4]&Ans&~correct&~FourSec | Q[2]&~FourSec;
    assign D[1] = Q[3]&FourSec | Q[2]&FourSec | Q[1]&~FourSec;
    assign D[0] = Q[1]&Over&FourSec | Q[0]&~Go;
    
    // State Machine FlipFlops in onehot implementation
    // Note: One and only one flipflop must be initialized to 1
    FDRE #(.INIT(1'b0)) FF4_0[4:0] (.C({5{clk}}), .CE({5{1'b1}}), .D(D[4:0]), .Q(Q[4:0]));
    FDRE #(.INIT(1'b1)) FF5 (.C(clk), .CE(1'b1), .D(D[5]), .Q(Q[5]));
    
    // Moore Vars
    assign ShowScore = Q[1] | Q[2] | Q[3] | Q[0];
    assign ShowArgs = Q[4];
    assign FlashL = Q[3] | Q[0];
    assign FlashR = Q[2] | Q[0];
    assign RunLFSR = Q[5] | Q[0];
    
    // Mealy Vars
    assign RTimer = Q[5]&Go | Q[4]&Ans&correct&~FourSec | Q[4]&FourSec | Q[4]&Ans&~correct&~FourSec | Q[3]&FourSec | Q[2]&FourSec | Q[0]&Go;
    assign cntL = Q[3]&FourSec;
    assign cntR = Q[2]&FourSec;
    assign RScore = Q[0]&Go;
    
endmodule
