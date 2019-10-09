% ECE251 Assignment 2: Baseband and Passband
% Written by Stephen Kemp, 10/08/2019
% Givens:
% Each symbol a[n] corresponds to two bits. a[n] = +/-1+/-j
% Symbols are transmitted on a rectangular pulse p(t) with duration 
% T = 0.001s, whose amplitude is a[n].
% s(t) = a[0]p(t) + a[1]p(t-T) + a[2]p(t-2T) + ... + a[n]p(t-nT)

close all;
clear all;
clc;

%% 1. Generate the baseband signal s(t), using a random sequence of bits
T0 = 0.001;
fs = 15000;
n = 10; % number of 2-bit symbols

N = T0*n; % total time
Ts = 1/fs;
t = 0:Ts:N;

%generate random 2-bit symbols a[n]
re = randi([0,1],[1,n]);
re = re.*2 - 1; %adjusts 0s and 1s to -1 and 1
im = randi([0,1],[1,n]);
im = im.*2 - 1; %adjusts 0s and 1s to -1 and 1
a = re + i*im;
s = vect_expand(a,length(t));

figure(1);
plot(t,s)
%% 2. Go to passband and back as follows:

% a. Generate the analytic passband signal x+(t) with carrier frequency of
% f_c = 4kHz

% b. Convert the analytic signal into a passband signal x1(t)

% c. Convert the passband signal x1(t) into an analytic signal x1+(t) and
% then back into a baseband signal z1(t)

% d. Calculate and plot the magnitude spectra of: s(t), x+(t), x1+(t),
% z1(t) (The spectra should be averaged over multiple data blocks).


%% 3. Go to passband and back as follows:

% a. Use a quadrature modulator to convert s(t) into a passband signal
% x2(t) with carrier frequency of fc = 4kHz

% b. Use a quadrature demodulator to convert the passband signal x2(t) back
% into a baseband signal z2(t)

% c. Calculate and plot the magnitude spectra of x2(t), z2(t). (The spectra
% should be averaged over multiple data blocks).


%% 4. Plot and compare the baseband signals s(t), z1(t) and z2(t). Explain
% and discuss what differences you may see. (In the explanation document.)

%% Helper Functions
%vect_exp: expands vector x to be length N, but keeping previous values,
%effectively increasing the resolution. Uses truncation rule i.e. fix()
function e = vect_expand(x,N)
if N < length(x)
    error('N must be >= length(x)');
    return
end

old_N = length(x);
e = zeros(1,N);
step = old_N/N;
for n = 1:N
   e(n) = x(fix(n*step-step)+1);
end
end
















