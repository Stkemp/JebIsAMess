% ECE 251 assignment 1: Due noon, Monday Oct 7, 2019
% Given: 
%   - The noise is complex Gaussian white noise with zero mean and
%       variance sigma^2
%   - The filter has a 3dB bandwidth of 10kHz and an attenuation of 50dB
%       at 12kHz. The DC gain is 20dB.

close all;
clear all;
clc

%% 1. Determine the variance of the noise to correspond to thermal reciever
% noise assuming temperature T = 300K and a noise figure NF = 5dB.
Tk = 300; %Kelvin
k = 1.381E-23; %Joules/Kelvin
var = Tk*k/4; %Joules (see explanation of part 1 for formula rationale)
fprintf('1) variance of noise: ');
fprintf(num2str(var));
fprintf(' Joules\n')

%% 2. Design LPF and plot its mag-squared frequency response (use fir1)
%KNOBS
fs = 40000; % sampling frequency
cutoff = 10000;
order = 500;
N = 5; % number of seconds
DC_gain_scalar = 10; % tuned to give passband gain of ~20dB

Ts = 1/fs;
t = 0:Ts:N;

% filt = fir1(order, cutoff/fs/2); % LPF. 1 in 2nd arg corresponds to fs/2
filt = DC_gain_scalar.*fir1(order, 2*cutoff/fs);
F_mag = abs(fft(filt, round(length(t)/2))); %frequency domain filter magnitude
F_mag = (F_mag(1:round(length(F_mag)/2))); %just want the positive freqs 0 to pi
F_magsqDB = 20*log10(F_mag); %calculate the magnitude squared values in DB
f = linspace(1,fs/2,length(F_magsqDB));

% Plot results
figure(1)
subplot(3,1,1)
plot(f,F_magsqDB)
title('2) Magnitude squared plot of LPF')
xlabel('frequency (Hz)')
ylabel('dB')
ylim([-70,30])

%% 3. Generate complex noise vector and pass it through the filter to get y
std = sqrt(var);
%default normal std dev = 1, so have to scale it.
r = randn(length(t),1)*std; %generate real white noise
im = randn(length(t),1)*std; %generate imaginary white noise
v = r + i.*im;

% compute PSD of unfiltered noise
num_chunks = 50; %number of PSD chunks to average
P_v = PSD(v,t,num_chunks,fs);
P_v_positive = P_v(1:fix(length(P_v)/2));
w_v = linspace(0,fs/2,length(P_v_positive));

% [PSD_check,w_v_check] = periodogram(v);
% figure(2)
% 
% N = length(v);
% vdft = fft(v);
% vdft = vdft(1:N/2+1);
% PSD_check = (1/(fs*N)) * abs(vdft).^2;
% PSD_check(2:end-1) = 2*PSD_check(2:end-1);
% w_v_check = 0:fs/N:fs/2;
% 
% plot(w_v_check, 10*log10(PSD_check));
% figure(1)

subplot(3,1,2)
plot(w_v,10*log10(P_v_positive))
title('Power Spectral Density of Unfiltered White Noise')
xlabel('frequency (Hz)')
ylabel('dB')
%compute y[n] using filter
y = filter(filt,1,v);
%% 4. Compute and plot the spectrum of the noise at the output of the 
% filter by averaging the magnitude squared Fourier transform of 50 blocks
% of the output data y[n]. The frequency resolution of the spectrum should
% be 10Hz or less.
%KNOBS
NF_dB = 5; %noise figure of reciever
num_chunks = 50; %number of PSD chunks to average

P_y = PSD(y,t,num_chunks,fs);
P_y = P_y.*10^(NF_dB/10); %multiply in noise figure
P_y_positive = P_y(1:fix(length(P_y)/2));
w = linspace(0,fs/2,length(P_y_positive));

subplot(3,1,3)
plot(w,10*log10(P_y_positive))
title('4) Power Spectral Density of Filtered White Noise')
xlabel('frequency (Hz)')
ylabel('dB')

%% 5. Compute the total noise power at the filter output
sum = 0;
res = w(2)-w(1);
for k = 1:length(P_y)
    sum = P_y(k)*res;
end
fprintf('5) total filtered signal power: ')
fprintf(num2str(sum));
fprintf(' Watts\n');

%%--------------------------Helper functions------------------------------
%PSD: calculates the power spectral density of a signal x using
%Wiener-Khinchin method
%args: x - input signal vector
%   t - corresponding time vector
%   N - number of chunks
%output: P - PSD vector
function [P] = PSD(x,t,N,fs)
T0 = (t(end) - t(1))/N;
chunk_len = fix(length(x)/N);
sum = zeros(chunk_len,1);
for k = 0:N-1
    chunk = x(chunk_len*k+1:chunk_len*(k+1));
    Chunk = fft(chunk,length(chunk));
    Chunk_magsq = abs(Chunk).^2;
    sum = sum + Chunk_magsq./(T0*fs);
end
P = sum/N;
end








