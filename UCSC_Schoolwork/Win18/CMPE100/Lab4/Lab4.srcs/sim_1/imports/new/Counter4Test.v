`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2018 04:29:10 PM
// Design Name: 
// Module Name: MultSim
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


module Counter4Test();

reg up;
reg dw;
reg ld;
reg [3:0] Din;
reg clkin;
wire [3:0] Q;
wire UTC;
wire DTC;

CountUD4L UUT (clkin, up, dw, ld, Din, Q, UTC, DTC);

parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        #OFFSET
                  clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
        end
        
   initial
   begin
         // add your stimuli here
         // to set signal foo to value 0 use
         // foo = 1'b0;
         // to set signal foo to value 1 use
         // foo = 1'b1;
         //always advance time my multiples of 100ns
         // to advance time by 100ns use the following line
        up = 1'b0;
        dw = 1'b0;
        ld = 1'b0;
        Din = 4'b0000;
        #100;
        
        #200;
        up = 1'b0;
        #200;
        ld = 1'b1;
        #100;
        Din = 4'b0001;
        #100;
        ld = 1'b0;
        #100;
        up = 1'b1;
        #300;
        up = 1'b0;
        #100;
        dw = 1'b1;
        #200;
        up = 1'b0;
        #100;
        Din = 4'b0110;
        ld = 1;
        
        end
endmodule
