`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2018 06:31:18 PM
// Design Name: 
// Module Name: Top
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


module Top(
    input clkin,
    input btnR,
    input btnU,
    input btnD,
    input btnC,
    input btnL,
    input [15:0] sw,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [15:0] led
    );
    
    wire [15:0] Q;
    wire [3:0] H, sel;
    wire clk, digsel, fastCount, pressCountUp, pressCountDown, UTC, DTC;
    
    lab4_clks myClks (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));
    BTNC_logic ContinuousCount (Q, btnC, clk, fastCount);
    Edge_Detector btnUEdge (btnU, clk, pressCountUp);
    Edge_Detector btnDEdge (btnD, clk, pressCountDown);
    counterUD16L myCounter (clk, sw, pressCountUp | fastCount, pressCountDown, btnL, Q, UTC, DTC);
    Ring_Counter myRingCounter (digsel, clk, sel);
    Selector mySelector (sel, Q, H);
    hex7seg myHex7Seg (H, seg);
    
    assign an = ~sel;
    assign dp = (~UTC|DTC|~sel[3]|sel[0]) & (UTC|~DTC|sel[3]|~sel[0]); 
    //assign dp = ~UTC;
    assign led = sw;
    
    
endmodule
