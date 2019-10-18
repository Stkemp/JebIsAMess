% ECE251 Assignment 3: Baseband 4-PAM, SRRC filters and Eye Diagrams
% Written by Stephen Kemp, 10/17/19

clear all;
close all;
clc;

%% 1. Generate a sequence of real 4-PAM symbols at 2000 symbols/second
fsym = 2000;
fs = 16*fsym; %should be an even multiple of symbol frequency for filtering???
n = 5000; % number of 2-bit 4PAM symbols
symbols_per_block = 50; % sets symbols/block when calculating PSD

Tsym = 1/fsym; % symbol pulse duration
Ts = 1/fs;
N = Tsym*n; % total time
t = 0:Ts:N;
t = t(1:end-1); % cut off element

%generate random 4PAM symbols
a = randi([0,3],[1,n]);
a = a.*2 - 3; %maps 0,1,2,3 to -3,-1,1,3
a = vect_expand(a,length(t)); % upsample a to fit t

A = PSD(a,t,n/symbols_per_block,fs);
f = linspace(-fs/2,fs/2,length(A));

%% 2. Pass the sequence through an SSRC TX filter w/ alpha = 20% to get
% the TX baseband signal s(t)
alpha = .2; % 20% excess bandwidth
span = 16; % number of symbols spanned by filter
sps = fs/fsym; % number of samples/symbol

SRRC = rcosdesign(alpha,span,sps,'sqrt'); % generate SRRC filter
s = filter(SRRC,1,a);
s = s(fix(length(SRRC)/2):end); %get rid of signal delay

figure(1)
stem(SRRC)

SRRC_dft = fftshift(fft(SRRC));
figure(2)
plot(1:length(SRRC_dft),20*log10(abs(SRRC_dft)))

S = PSD(s,t,n/symbols_per_block,fs);

%% 3. Pass the signal s(t) through an SSRC RX filter to get the filtered
% signal y(t)
y = filter(SRRC,1,s); %SRRC is its own matched filter because of it's symmetry
y = y(fix(length(SRRC)/2):end); %get rid of signal delay

%% 4. Generate and plot an eye diagram of the signal y(t)

figure(3)
eyediagram(y,sps*2);
title('Eye diagram of recieved signal y(t)');
xlabel('samples');
ylabel('Signal Amplitude (V)');
%% 5. Calculate and plot the PSD of s(t) and y(t)

%% 6. Implement a mechanism for detecting the symbols a'[n] from y(t)

%% 7. Compare the detected symbols to the original symbols and calculate
% the symbol error rate #incorrect_symbols/num_symbols (should be zero)

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

%PSD: calculates the power spectral density of a signal x using
%Wiener-Khinchin method
%args: x - input signal vector
%   t - corresponding time vector
%   N - number of chunks
%output: P - PSD vector
function [P] = PSD(x,t,N,fs)
T0 = (t(end) - t(1))/N;
chunk_len = fix(length(x)/N);
sum = zeros(1,chunk_len);
for k = 0:N-1
    chunk = x(chunk_len*k+1:chunk_len*(k+1));
    Chunk = fft(chunk,length(chunk));
    Chunk_magsq = abs(Chunk).^2;
    sum = sum + Chunk_magsq./(T0*fs);
end
P = sum/N;
P = fftshift(P);
end

% eyediagram(x,n): plots the eye diagram of signal x in active figure
% n: number of samples per trace
% t: corresponding time vector to x (lengths must be equal)
function eyediagram(x,n)
N = fix(length(x)/n); % number of traces to plot
hold on;
for k = 1:n:N*n
    plot(1:n, x(k:k+n-1))
end
hold off;
end












