`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2018 02:53:00 PM
// Design Name: 
// Module Name: VGAController
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


module VGAController(
    input clk,
    output Hsync,
    output Vsync,
    output [9:0] Hadd,
    output [9:0] Vadd,
    output Active
    );
    
    wire [15:0] HQ, VQ;
    wire TC799, TC524;
    
    counterUD16L HCounter (.clk(clk), .Din({16'b0}), .up(1'b1), .dw(1'b0), .ld(TC799), .Q(HQ));
    counterUD16L VCounter (.clk(clk), .Din({16'b0}), .up(TC799), .dw(1'b0), .ld(TC799 & TC524), .Q(VQ)); 
        
    assign TC799 = HQ == 10'd799;
    assign TC524 = VQ == 10'd524;
    
    assign Hsync = HQ < 655 || HQ > 750;
    assign Vsync = VQ < 489 || VQ > 490;
    assign Active = HQ < 640 && VQ < 480;
    
    assign Hadd = HQ[9:0];
    assign Vadd = VQ[9:0];
    
endmodule
