`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2018 03:55:16 PM
// Design Name: 
// Module Name: StateMachineTest
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


module StateMachineTest();
reg clkin, Go, Ans, correct, Over, FourSec;
wire ShowScore, ShowArgs, RTimer, cntL, cntR, FlashL, FlashR, RunLFSR, RScore;

State_Machine UUT (clkin, Go, Ans, correct, Over, FourSec, ShowScore, ShowArgs, RTimer, cntL, cntR, FlashL, FlashR, RunLFSR, RScore);

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
 Go = 1'b0;
 Ans = 1'b0;
 correct = 1'b0;
 Over = 1'b1;
 FourSec = 1'b0;
 #100;
 Go = 1;
 #50;
 Go = 0;
 FourSec = 1;
 #50;
 FourSec = 0;
 #50;
 Go = 1;
            
            
    end
            
endmodule
