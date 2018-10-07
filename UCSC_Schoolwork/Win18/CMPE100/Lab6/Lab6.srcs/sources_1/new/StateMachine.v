`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2018 02:23:23 PM
// Design Name: 
// Module Name: StateMachine
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


module StateMachine(
    input clk,
    input left,
    input right,
    output CountU,
    output CountD,
    output RTimer,
    output DispTimer
    );
    
    wire [4:0] D, Q;
    
    FDRE #(.INIT(1'b1) ) Q4 (.C(clk), .CE(1'b1), .D(D[4]), .Q(Q[4]));
    FDRE #(.INIT(1'b0)) Q0123[3:0] (.C({4{clk}}), .CE({4{1'b1}}), .D(D[3:0]), .Q(Q[3:0]));
    
    assign D[4] = Q[4]&~left&~right | Q[3]&~left&~right | Q[2]&~left&~right | Q[1]&~left&~right | Q[0]&~left&~right;
    assign D[3] = Q[4]&left | Q[3]&left&~right;
    assign D[2] = Q[4]&~left&right | Q[2]&~left&right;
    assign D[1] = Q[3]&right | Q[1]&right | Q[0]&~left&right;
    assign D[0] = Q[2]&left | Q[1]&left&~right | Q[0]&left;
    
    assign CountU = Q[1]&~left&~right;
    assign CountD = Q[0]&~left&~right;
    assign RTimer = Q[4]&left | Q[4]&~left&right;
    assign DispTimer = |Q[3:0];
    
endmodule
