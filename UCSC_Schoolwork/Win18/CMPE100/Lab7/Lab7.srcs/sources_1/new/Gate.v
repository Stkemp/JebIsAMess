`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2018 10:26:34 PM
// Design Name: 
// Module Name: Gate
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


module Gate(
input clk,
input NewFrame,
input GameReset,
input MovePieces,
input GateTop,
input [3:0] plusminus,
input [3:0] prevgateH,
input [15:0] initV,
input [3:0] initH,
output [3:0] GHP,
output [15:0] GVP

    );
    wire [15:0] resetVal;
    wire [3:0] NGHP, Hin;
    
    //Generate next Gate Values
    GHPgen GateGen(.prevgate(prevgateH), .plusminus(plusminus), .thisgate(NGHP));
    m4_1x4 GHMux(.in0(NGHP), .in1(initH), .in2(4'b0), .in3(4'b0), .sel({1'b0,GameReset}), .e(1'b1), .o(Hin));
    //Horizontal Registers for Gate1
    FDRE #(.INIT(1'b0)) GFF1 (.C(clk), .CE(GVP == 0 && NewFrame || GameReset), .D(Hin[0]), .Q(GHP[0]));
    FDRE #(.INIT(1'b0)) GFF2 (.C(clk), .CE(GVP == 0 && NewFrame || GameReset), .D(Hin[1]), .Q(GHP[1]));
    FDRE #(.INIT(1'b0)) GFF3 (.C(clk), .CE(GVP == 0 && NewFrame || GameReset), .D(Hin[2]), .Q(GHP[2]));
    FDRE #(.INIT(1'b0)) GFF4 (.C(clk), .CE(GVP == 0 && NewFrame || GameReset), .D(Hin[3]), .Q(GHP[3]));
    //Gate Vertical Counter
    m2_1x16 GVmux(.in0(16'b0000000111100000), .in1(initV), .sel(GameReset), .o(resetVal));
    counterUD16L GVCount (.clk(clk), .Din(resetVal), .up(1'b0), .dw(NewFrame&MovePieces), .r(1'b0),
     .ld(GVP == 10'd0 && NewFrame && GateTop|| GameReset), .Q(GVP));

    
endmodule
