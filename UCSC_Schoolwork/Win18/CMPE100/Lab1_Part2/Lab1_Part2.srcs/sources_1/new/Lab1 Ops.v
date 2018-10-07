`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2018 02:01:48 PM
// Design Name: 
// Module Name: Lab1 Ops
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


module Lab1_Ops(
    input BTNU,
    output LD0,
    input BTNL,
    input BTNR,
    output LD1,
    input SW0,
    input SW1,
    input SW2,
    output LD2,
    output LD3
    );
    
    assign LD0 = ~BTNU;
    assign LD1 = BTNL & BTNR;
    assign LD2 = SW0 | SW1;
    assign LD3 = SW0 ^ SW1 ^ SW2;
    
endmodule
