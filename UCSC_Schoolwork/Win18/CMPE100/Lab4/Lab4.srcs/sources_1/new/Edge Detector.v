`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2018 03:52:44 PM
// Design Name: 
// Module Name: Edge Detector
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


module Edge_Detector(
    input in,
    input clk,
    input out
    );
    
    wire a, b;
    
    FDRE #(.INIT(1'b0) ) ff1(.C(clk), .R(1'b0), .CE(1'b1), .D(in), .Q(a));
    FDRE #(.INIT(1'b0) ) ff2(.C(clk), .R(1'b0), .CE(1'b1), .D(a), .Q(b));
    assign out = a & ~b & in;
    
endmodule
