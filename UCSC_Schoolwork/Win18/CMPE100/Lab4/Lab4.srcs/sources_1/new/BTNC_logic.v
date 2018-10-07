`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2018 02:46:13 PM
// Design Name: 
// Module Name: BTNC_logic
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


module BTNC_logic(
    input [15:0] Q,
    input btnC,
    input clk,
    output out
    );
    
    wire Q_is_in_range, D;
    assign Q_is_in_range = ~(&Q[15:2] | &Q[15:3]&Q[1]&Q[0]);
    assign D = Q_is_in_range & btnC;
    FDRE #(.INIT(1'b0) ) ff1(.C(clk), .R(1'b0), .CE(1'b1), .D(D), .Q(out));
    
endmodule
