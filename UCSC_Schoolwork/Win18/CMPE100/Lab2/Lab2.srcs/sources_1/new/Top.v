`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2018 02:18:53 PM
// Design Name: 
// Module Name: Top
// Project Name: Lab2
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


module Top(
    input sw0,
    input sw1,
    input sw2,
    input sw3,
    input sw4,
    input sw5,
    input sw6,
    output a0,
    output a1,
    output a2,
    output a3,
    output dp,
    output ca,
    output cb,
    output cc,
    output cd,
    output ce,
    output cf,
    output cg
    );
    
    wire s0, s1, s2, s3;
    
    assign a0 = 0;
    assign a1 = 1;
    assign a2 = 1;
    assign a3 = 1;
    assign dp = 1;
    
    Adder myAdder (.cin(sw0), .a0(sw1), .a1(sw2), .a2(sw3), .b0(sw4), .b1(sw5), .b2(sw6), .s0(s0), .s1(s1), .s2(s2), .s3(s3));
    SevenSegLogic mySevenSeg (.n0(s0), .n1(s1), .n2(s2), .n3(s3), .a(ca), .b(cb), .c(cc), .d(cd), .e(ce), .f(cf), .g(cg));
    
endmodule
