`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2018 02:38:35 PM
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
    input btnL,
    input btnR,
    input btnU,
    output led15,
    output led9,
    output [3:0] an,
    output [6:0] seg
    );
    
    wire btnLsync, btnRsync, CountU, CountD, RTimer, DispTimer, qsec;
    wire [3:0] sel, tohex7seg;
    wire [5:0] DC;
    wire [7:0] QC, QT;
    wire [6:0] Q2SC, QC2SC, toseg;
    
    assign zero = 1'b0;
    
    lab6_clks myclks (.clkin(clkin), .greset(btnU), .clk(clk), .digsel(digsel), .qsec(qsec));
    
    // synchronize inputs
    FDRE #(.INIT(1'b0)) btnL_FF (.C(clk), .CE(1'b1), .D(btnR), .Q(btnRsync));
    FDRE #(.INIT(1'b0)) btnR_FF (.C(clk), .CE(1'b1), .D(btnL), .Q(btnLsync));
    
    StateMachine BigBoss(clk, btnLsync, btnRsync, CountU, CountD, RTimer, DispTimer);
    CountUDL8 TurkeyCounter(clk, CountU, CountD, 1'b0, 8'b00000000, QC);
    CountUDL8 TimeCounter(clk, qsec&~(&QT[5:2]), 1'b0, RTimer, 8'b00000000, QT);
    
    Adder8 Addone({1'b0, ~QC[6:0]}, 8'b00000000, 1'b1, {DC[0], Q2SC[6:0]}, DC[1]);
    m2_1x8 SC2Mux({1'b0, QC[6:0]}, {1'b0, Q2SC[6:0]}, QC[7], 1'b1, {DC[2], QC2SC[6:0]});
    
    Ring_Counter MyCounter(digsel, clk, sel);
    Selector MySelector(sel, {QT[5:2], 4'b0000, 1'b0, QC2SC[6:0]}, tohex7seg);
    hex7seg myHex7Seg(tohex7seg, toseg);
    
    // inverts '0' to '-' when sel[2] is active
    assign seg[6:0] = toseg ^ {7{sel[2]}};
    
    // assign anodes
    assign an[1:0] = ~sel[1:0];
    assign an[2] = ~(sel[2]&QC[7]);
    assign an[3] = ~(sel[3]&DispTimer);
    
    // assign leds
    assign led15 = ~btnL;
    assign led9 = ~btnR;
    
    
endmodule
