close all;
clear all;
clc

fs = 1000;
Ts = 1/fs;
f0 = 50;
N = 1;

t = 0:Ts:N;
x = sin(2*pi()*f0*t);

figure(1)
plot(t,x)

figure(2)
X = abs(fft(x));
X = X(1:length(X)/2);
f = linspace(1,fs/2,length(t)/2);
plot(f,X)
