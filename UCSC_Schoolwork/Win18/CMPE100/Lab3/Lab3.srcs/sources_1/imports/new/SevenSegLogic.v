`timescale 1ns / 1ps


module SevenSegLogic(
    input n0,
    input n1,
    input n2,
    input n3,
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g
    );
    
    wire h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, ha, hb, hc, hd, he, hf;
    
    assign h0 =  ~n3&~n2&~n1&~n0;
    assign h1 =  ~n3&~n2&~n1&n0;
    assign h2 =  ~n3&~n2&n1&~n0;
    assign h3 =  ~n3&~n2&n1&n0;
    assign h4 =  ~n3&n2&~n1&~n0;
    assign h5 =  ~n3&n2&~n1&n0;
    assign h6 =  ~n3&n2&n1&~n0;
    assign h7 =  ~n3&n2&n1&n0;
    assign h8 =  n3&~n2&~n1&~n0;
    assign h9 =  n3&~n2&~n1&n0;
    assign ha =  n3&~n2&n1&~n0;
    assign hb =  n3&~n2&n1&n0;
    assign hc =  n3&n2&~n1&~n0;
    assign hd =  n3&n2&~n1&n0;
    assign he =  n3&n2&n1&~n0;
    assign hf =  n3&n2&n1&n0;
    
    assign a = h1 | h4 | hb | hd;
    assign b = h5 | h6 | hb | hc | he | hf;
    assign c = h2 | hc | he | hf;
    assign d = h1 | h4 | h7 | h9 | ha | hf;
    assign e = h1 | h3 | h4 | h5 | h7 | h9;
    assign f = h1 | h2 | h3 | h7 | hd;
    assign g = h0 | h1 | h7 | hc;
    
endmodule
