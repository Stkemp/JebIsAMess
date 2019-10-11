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
fs = 12000;
n = 10000; % number of 2-bit symbols
symbols_per_block = 100;

N = T0*n; % total time
Ts = 1/fs;
t = 0:Ts:N;

%generate random 2-bit symbols a[n]
re = randi([0,1],[1,n]);
re = re.*2 - 1; %adjusts 0s and 1s to -1 and 1
im = randi([0,1],[1,n]);
im = im.*2 - 1; %adjusts 0s and 1s to -1 and 1
a = re + i*im;
s = vect_expand(a,length(t)); % upsample a to fit t

% ang = angle(fft(s));
% S = PSD(s,t,n/symbols_per_block,fs);
% S = [S(length(S)/2+1:length(S)),S(1:length(S)/2)]; % 0 to 2pi -> -pi to pi
% f_S = linspace(-fs/2,fs/2,length(S));
% 
% figure(1)
% plot(f_S, 10*log10(S))
% figure(2)
% plot(linspace(-fs/2,fs/2,length(ang)), 180/pi*ang);


%% 2. Go to passband and back as follows:

% a. Generate the analytic passband signal x+(t) with carrier frequency of
% f_c = 4kHz
fc = 4000;
f_cutoff = 1000;
order = 1000;

c = exp(i*2*pi*fc*t);
filt = fir1(order, 2*f_cutoff/fs);

x_plus = filter(filt,1,s); %bandlimit baseband signal
x_plus = c.*x_plus; %modulate signal with 4kHz carrier

% b. Convert the analytic signal into a passband signal x1(t)
x1 = real(x_plus);

% c. Convert the passband signal x1(t) into an analytic signal x1+(t) and
% then back into a baseband signal z1(t)
x1_plus = hilbert(x1);
z1 = x1_plus .* exp(i*2*pi*-fc*t);

% d. Calculate and plot the magnitude spectra of: s(t), x+(t), x1(t),
% x1+(t), z1(t) (The spectra should be averaged over multiple data blocks).
S = PSD(s,t,n/symbols_per_block,fs);
S = [S(length(S)/2+1:length(S)),S(1:length(S)/2)]; % 0 to 2pi -> -pi to pi
X_plus = PSD(x_plus,t,n/symbols_per_block,fs);
X_plus = [X_plus(length(X_plus)/2+1:length(X_plus)),X_plus(1:length(X_plus)/2)];
X1 = PSD(x1,t,n/symbols_per_block,fs);
X1 = [X1(length(X1)/2+1:length(X1)),X1(1:length(X1)/2)];
X1_plus = PSD(x1_plus,t,n/symbols_per_block,fs);
X1_plus = [X1_plus(length(X1_plus)/2+1:length(X1_plus)),X1_plus(1:length(X1_plus)/2)];
Z1 = PSD(z1,t,n/symbols_per_block,fs);
Z1 = [Z1(length(Z1)/2+1:length(Z1)),Z1(1:length(Z1)/2)];
f = linspace(-fs/2,fs/2,length(S));

% plot s, x+, x1, x1+, z1
figure(1)
subplot(5,1,1);
plot(f,10*log10(S))
title('Original Signal s(t) PSD');
ylabel('dB');
xlabel('frequency (Hz)');
subplot(5,1,2);
plot(f,10*log10(X_plus));
title('Analytic Passband Signal x+(t) (4kHz modulation) PSD');
ylabel('dB');
xlabel('frequency (Hz)');
subplot(5,1,3);
plot(f,10*log10(X1));
title('Real Passband Signal x1(t) PSD');
ylabel('dB');
xlabel('frequency (Hz)');
subplot(5,1,4);
plot(f,10*log10(X1_plus));
title('Recieved Analyitic Passband Signal x1+(t) PSD');
ylabel('dB');
xlabel('frequency (Hz)');
subplot(5,1,5);
plot(f,10*log10(Z1));
title('Recieved Baseband Signal z1(t) PSD');
ylabel('dB');
xlabel('frequency (Hz)');

%% 3. Go to passband and back as follows:

% a. Use a quadrature modulator to convert s(t) into a passband signal
% x2(t) with carrier frequency of fc = 4kHz
x2 = filter(filt,1,s); %bandlimit baseband signal
x2 = real(x2).*cos(2*pi*fc*t) + imag(x2).*sin(2*pi*fc*t);

% b. Use a quadrature demodulator to convert the passband signal x2(t) back
% into a baseband signal z2(t)
u = x2.*2.*cos(2*pi*fc*t); %real part of demod signal
v = x2.*2.*sin(2*pi*fc*t); %imaginary part of demod signal
u = filter(filt,1,u);   
v = filter(filt,1,v);
z2 = u + i.*v; %reconstruct complex baseband signal
% have to scale by 2 to compensate for filtered signal power

% c. Calculate and plot the magnitude spectra of x2(t), z2(t). (The spectra
% should be averaged over multiple data blocks).
X2 = PSD(x2,t,n/symbols_per_block,fs);
X2 = [X2(length(X2)/2+1:length(X2)),X2(1:length(X2)/2)];
Z2 = PSD(z2,t,n/symbols_per_block,fs);
Z2 = [Z2(length(Z2)/2+1:length(Z2)),Z2(1:length(Z2)/2)];

figure(2)
subplot(2,1,1);
plot(f,10*log10(X2))
title('Quadrature Modulated Passband Signal x2(t) PSD');
ylabel('dB');
xlabel('frequency (Hz)');
subplot(2,1,2);
plot(f,10*log10(Z2));
title('Quadrature Demodulated Baseband Signal z2(t) PSD');
ylabel('dB');
xlabel('frequency (Hz)');


%% 4. Plot and compare the baseband signals s(t), z1(t) and z2(t). Explain
% and discuss what differences you may see. (In the explanation document.)
n_symbols = 120;
n_samples = fix(n_symbols*length(t)/n);
figure(3);
subplot(3,2,1);
plot(t(1:n_samples),real(s(1:n_samples)));
title('Real Part of Original Signal s(t)');
ylabel('signal amplitude(V)');
xlabel('time(s)');
subplot(3,2,2);
plot(t(1:n_samples),imag(s(1:n_samples)));
title('Imaginary Part of Original Signal s(t)');
ylabel('signal amplitude(V)');
xlabel('time(s)');
subplot(3,2,3);
plot(t(1:n_samples),real(z1(1:n_samples)));
title('Real Part of Recieved Signal z1(t)');
ylabel('signal amplitude(V)');
xlabel('time(s)');
subplot(3,2,4);
plot(t(1:n_samples),imag(z1(1:n_samples)));
title('Imaginary Part of Recieved Signal z1(t)');
ylabel('signal amplitude(V)');
xlabel('time(s)');
subplot(3,2,5);
plot(t(1:n_samples),real(z2(1:n_samples)));
title('Real Part of Recieved Signal z2(t)');
ylabel('signal amplitude(V)');
xlabel('time(s)');
subplot(3,2,6);
plot(t(1:n_samples),imag(z2(1:n_samples)));
title('Imaginary Part of Recieved Signal z2(t)');
ylabel('signal amplitude(V)');
xlabel('time(s)');



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
end
















