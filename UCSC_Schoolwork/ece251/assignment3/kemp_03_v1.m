% ECE251 Assignment 3: Baseband 4-PAM, SRRC filters and Eye Diagrams
% Written by Stephen Kemp, 10/17/19

clear all;
close all;
clc;

%% 1. Generate a sequence of real 4-PAM symbols at 2000 symbols/second
fsym = 2000;
fs = 8*fsym;
n = 10000; % number of 2-bit 4PAM symbols
symbols_per_block = 50; % sets symbols/block when calculating PSD

Tsym = 1/fsym; % symbol pulse duration
Ts = 1/fs;
N = Tsym*n; % total time
t = 0:Ts:N;
t = t(1:end-1); % cut off element

%generate random 4PAM symbols
a = randi([0,3],[1,n]);
a = a.*2 - 3; %maps 0,1,2,3 to -3,-1,1,3
a_t = vect_expand(a,length(t)); % upsample a to fit t

A = PSD(a_t,t,n/symbols_per_block,fs);
f = linspace(-fs/2,fs/2,length(A));

%% 2. Pass the sequence through an SSRC TX filter w/ alpha = 20% to get
% the TX baseband signal s(t)
alpha = input('enter a value for SRRC filter alpha (0-1): '); % 20% excess bandwidth
span = 8; % number of symbols spanned by filter
sps = fs/fsym; % number of samples/symbol
filter_scalar = 1.108/sqrt(sps); %tuned to account for filter scaling

SRRC = rcosdesign(alpha,span,sps,'sqrt')*filter_scalar; % generate SRRC filter
s = filter(SRRC,1,a_t);
% s = s(fix(length(SRRC)/2):end); %get rid of signal delay

% figure(1)
% stem(SRRC)
% title('SRRC filter stem plot');
% ylabel('magnitude (V)');
% xlabel('sample');

%% 3. Pass the signal s(t) through an SSRC RX filter to get the filtered
% signal y(t)
y = filter(SRRC,1,s); %SRRC is its own matched filter because of it's symmetry
% y = y(fix(length(SRRC)/2):end); %get rid of signal delay

% figure(4)
% subplot(2,1,1);
% plot(1:1000,a_t(1:1000));
% subplot(2,1,2);
% plot(1:1000,y(1:1000));

%% 4. Generate and plot an eye diagram of the signal y(t)

figure(2)
eyediagram(y,sps*2);
title('Eye diagram of recieved signal y(t)');
xlabel('samples');
ylabel('Signal Amplitude (V)');
%% 5. Calculate and plot the PSD of s(t) and y(t)
S = PSD(s,t,n/symbols_per_block,fs);
f_S = linspace(-fs/2,fs/2,length(S));
Y = PSD(y,t,n/symbols_per_block,fs);
f_Y = linspace(-fs/2,fs/2,length(Y));

figure (3);
subplot(2,1,1);
plot(f_S, 10*log10(S));
title('SRRC Filtered Transmit Signal PSD');
xlabel('frequency (Hz)');
ylabel('dB');
subplot(2,1,2);
plot(f_Y, 10*log10(Y));
title('SRRC Filtered Transmit Signal PSD');
xlabel('frequency (Hz)');
ylabel('dB');

%% 6. Implement a mechanism for detecting the symbols a_hat[n] from y(t)
start = length(SRRC)+fix(.5*sps); % account for double filter delay
finish = length(t);
a_hat = zeros(1,length(a));
j = 1; % a_hat index counter
for k = start:sps:finish
    % thresholds based on eye diagram
    if y(k)>2
        a_hat(j) = 3;
    elseif 0<y(k) & y(k)<=2
        a_hat(j) = 1;
    elseif -2<y(k) & y(k)<=0
        a_hat(j) = -1;
    else
        a_hat(j) = -3;
    end
    j = j+1;
end

%% 7. Compare the detected symbols to the original symbols and calculate
% the symbol error rate #incorrect_symbols/num_symbols (should be zero)

% truncate last <SRRC filter span> symbols cut out due to filter delay
a = a(1:end-span);
a_hat = a_hat(1:end-span);
num_errors = nnz(a - a_hat)
bit_error_rate = num_errors/length(a)

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
function eyediagram(x,n)
N = fix(length(x)/n); % number of traces to plot
hold on;
for k = 1:n:N*n
    plot(1:n, x(k:k+n-1))
end
hold off;
end











