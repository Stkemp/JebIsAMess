% ECE251 Assignment 5: 8-QAM Error Rate vs SNR Evaluation
% Written by Stephen Kemp, 10/24/19

clear all;
close all;
clc;
hold on;

%% 7. Generate BER/SER values for Eb/No
M = 8;
ber_opt = [];
ser_opt = [];
ber_sub = [];
ser_sub = [];
LPF_NP = [];
SRRC_NP = [];
P_E = [];
EbNo_dB = [];
EbNo = [];
% Run simulation
for k = 0:2:20
    EbNo_dB = [EbNo_dB k];
    EbNo = [EbNo 10^(k/10)];
    % 'optimal' simulation with 2 SRRC filters
    [n,b,s] = error_rate_simulation_8QAM_SRRC(10^(k/10));
    ber_opt = [ber_opt b];
    ser_opt = [ser_opt s];
    SRRC_NP = [SRRC_NP n];
    % 'suboptimal' simulation with 1 RC filter and a LPF
    [n,b,s] = error_rate_simulation_8QAM_suboptimal(10^(k/10));
    ber_sub = [ber_sub b];
    ser_sub = [ser_sub s];
    LPF_NP = [LPF_NP n];
    % Theoretic probability of symbol error for this 8QAM constellation
    P_E = [P_E (3/2*erfc(sqrt(3/(3+sqrt(3)))*sqrt(10^(k/10))))];
end

noise_power_difference_dB = LPF_NP - SRRC_NP


ber_theo = P_E * 1.375/3; % See work in explanation of part 3

%% 8. Plot the following simulated AND theorectial data:
% SER vs. Eb/No
% BER vs. Eb/No

figure;
subplot(2,1,1);
semilogy(EbNo_dB, ser_opt, EbNo_dB, ser_sub, EbNo_dB, P_E);
ylim([1E-5,1])
legend('double SRRC', 'RC and LPF', 'theoretical');
title('Symbol Error Rate vs. EbNo');
ylabel('Symbol Error Rate');
xlabel('EbNo (dB)');

subplot(2,1,2);
semilogy(EbNo_dB, ber_opt, EbNo_dB, ber_sub, EbNo_dB, ber_theo);
ylim([1E-5,1])
legend('double SRRC', 'RC and LPF', 'theoretical');
title('Bit Error Rate vs. EbNo');
ylabel('Bit Error Rate');
xlabel('EbNo (dB)');

function [SRRC_NP, ber, ser] = error_rate_simulation_8QAM_SRRC(EbNo)
%% 1. Generate a random sequence a[n] of 8QAM symbols at 1000 symbol/sec
fsym = 1000;
sps = 8; % number of samples/symbol
fs = sps*fsym;
n = 200000; % number of 3-bit 8QAM symbols
symbols_per_block = 50; % sets symbols/block when calculating PSD
symbols = [1+i,1-i,-1+i,-1-i,1+sqrt(3)...
    ,-1-sqrt(3),i*(1+sqrt(3)),-i*(1+sqrt(3))]; %8QAM symbol list
% minimum penalty grey coding
bitmap = [0,0,0;
    1,0,0;
    0,1,0;
    1,1,0;
    1,0,1;
    0,1,1;
    0,0,1;
    1,1,1];
bitmap = bitmap';
M = 8; % number of combinations of bits
% symbols_per_block = 50; % sets symbols/block when calculating PSD

Tsym = 1/fsym; % symbol pulse duration
Ts = 1/fs;
N = Tsym*n; % total time
t = [0:Ts:N];
t = t(1:end-1); % cut off element

tbit_index = randi([1,length(symbols)],[1,n]); %generate symbol indexes
a = symbols(tbit_index); %map symbols from indexes
a_up = reshape([a;zeros(sps-1,length(a))], 1, []); %upsample a[n]

%% 2. Pass a[n] through a SRRC TX filter with excess bandwidth of 10% to
% get the TX baseband signal s(t). Scale the signal so as to get the signal
% power P according to the specified SNR or Eb/No
No = 1;
alpha = .1; % 10% excess bandwidth
span = 40; % number of symbols spanned by filter

Eb_desired = EbNo*No;
Es = mean(abs([symbols]).^2);
Eb = Es/log2(M);
Eb_scalar = sqrt(Eb_desired/Eb); %sqrt because Eb_des/Eb is a power conversion and we want magnitude scalar;

SRRC = rcosdesign(alpha,span,sps,'sqrt'); % generate SRRC filter
s = filter(SRRC,1,a_up);

%% 3. Add complex white Gaussian noise n(t) with variance No/2 to the
% baseband signal to get r(t) = s(t) + n(t)
variance = No/2;
stddev = sqrt(variance);
%default normal std dev = 1, so have to scale it.
re = randn(1,length(t))*stddev; %generate real white noise
im = randn(1,length(t))*stddev; %generate imaginary white noise
noise = re + i.*im;
noise = noise./Eb_scalar;

r = s + noise; % add Gaussian noise to signal

%% 4. Pass the signal r(t) through an SRRC recieve filter to get y(t)
y = filter(SRRC,1,r);

% Calculate total power of the SRRC-filtered noise
filt_t = [0:Ts:Ts*length(SRRC)];
SRRC_fft = abs(fftshift(fft(SRRC./sqrt(8)))).^2;
f_filt = linspace(-fs/2,fs/2,length(SRRC_fft));
filter_power = sum(SRRC_fft.*(f_filt(2)-f_filt(1)));
SRRC_NP = 10*log10(filter_power*No/Eb_scalar^2);

% S = PSD(s,t,n/symbols_per_block,fs);
% R = PSD(r,t,n/symbols_per_block,fs);
% Y = PSD(y,t,n/symbols_per_block,fs);
% f_S = linspace(-fs/2,fs/2,length(S));
% 
% figure;
% hold on;
% subplot(3,1,1);
% plot(f_S,10*log10(S));
% title('case 1: double SRRC');
% subplot(3,1,2);
% plot(f_S,10*log10(R));
% subplot(3,1,3);
% plot(f_S,10*log10(Y));
% title('y(t) Case 1 (EbNo = 10dB)');
% ylabel('power (dB)');
% xlabel('frequency');

%% 5. Detect the symbols a_hat[n] from the recieved signal y(t)
start = length(SRRC); % account for double filter delay
finish = length(t);
a_hat = zeros(1,length(a));
rbit_index = zeros(1,length(a));
sa = []; % sampled symbol values
j = 1; % a_hat index counter
for k = start:sps:finish
    % find constellation point with min distance to sample
    sa = [sa y(k)]; %sampled symbol
    [m, min_ind] = min(vecnorm(y(k)-symbols,2,1));
    rbit_index(j) = min_ind;
    a_hat(j) = symbols(min_ind);
    j = j+1;
end

%% 6. Compare the detected symbols a_hat[n] to the original symbols a[n]
% and caluculate the SER and BER (assuming Grey coding).
a = a(1:end-span);
a_hat = a_hat(1:end-span);
rbit_index = rbit_index(1:end-span);
tbit_index = tbit_index(1:end-span);
num_errors = nnz(a - a_hat);
ser = num_errors/(length(a));

% constellation plot for EbNo = 100 = 20dB
if EbNo == 100
    figure;
    constplot(symbols, sa);
    title(strcat('Constellation plot for 2 SRRC filt; EbNo=',...
        num2str(EbNo)));
    xlabel('real');
    ylabel('imag');
end

% Calculate generic bit error rate given bitmap
num_bits = length(a)*log2(M);
tbits = bitmap(:,tbit_index);
rbits = bitmap(:,rbit_index);
num_errors = sum(abs(rbits-tbits),'all');
ber = num_errors/num_bits;

end

function [LPF_NP, ber, ser] = error_rate_simulation_8QAM_suboptimal(EbNo)
%% 1. Generate a random sequence a[n] of 8QAM symbols at 1000 symbol/sec
fsym = 1000;
sps = 8; % number of samples/symbol
fs = sps*fsym;
n = 200000; % number of 3-bit 8QAM symbols
symbols_per_block = 50; % sets symbols/block when calculating PSD
symbols = [1+i,1-i,-1+i,-1-i,1+sqrt(3)...
    ,-1-sqrt(3),i*(1+sqrt(3)),-i*(1+sqrt(3))]; %8QAM symbol list
% minimum penalty grey coding
bitmap = [0,0,0;
    1,0,0;
    0,1,0;
    1,1,0;
    1,0,1;
    0,1,1;
    0,0,1;
    1,1,1];
bitmap = bitmap';
M = 8; % number of combinations of bits
% symbols_per_block = 50; % sets symbols/block when calculating PSD

Tsym = 1/fsym; % symbol pulse duration
Ts = 1/fs;
N = Tsym*n; % total time
t = [0:Ts:N];
t = t(1:end-1); % cut off element

tbit_index = randi([1,length(symbols)],[1,n]); %generate symbol indexes
a = symbols(tbit_index); %map symbols from indexes
a_up = reshape([a;zeros(sps-1,length(a))], 1, []); %upsample a[n]

%% 2. Pass a[n] through an RC TX filter with excess bandwidth of 10% to
% get the TX baseband signal s(t). Scale the signal so as to get the signal
% power P according to the specified SNR or Eb/No
No = 1;
alpha = .1; % 10% excess bandwidth
span = 24; % number of symbols spanned by filter

Eb_desired = EbNo*No;
Es = mean(abs([symbols]).^2);
Eb = Es/log2(M);
Eb_scalar = sqrt(Eb_desired/Eb); %sqrt because Eb_des/Eb is a power conversion and we want magnitude scalar;

RC = rcosdesign(alpha,span,sps,'normal'); % generate RC filter
s = filter(RC,1,a_up);

%% 3. Add complex white Gaussian noise n(t) with variance No/2 to the
% baseband signal to get r(t) = s(t) + n(t)
variance = No/2;
stddev = sqrt(variance);
%default normal std dev = 1, so have to scale it.
re = randn(1,length(t))*stddev; %generate real white noise
im = randn(1,length(t))*stddev; %generate imaginary white noise
noise = re + i.*im;
noise = noise./Eb_scalar;
r = s + noise; % add Gaussian noise to signal

%% 4. Pass the signal r(t) through an RX LPF to get y(t)
%design
f_cutoff = 550;
LPF = fir1(500,2*f_cutoff/fs);
y = filter(LPF,1,r)/max(RC);

% Calculate total power of the LPF-filtered noise
filt_t = [0:Ts:Ts*length(LPF)];
LPF_fft = abs(fftshift(fft(LPF))).^2;
f_filt = linspace(-fs/2,fs/2,length(LPF_fft));
filter_power = sum(LPF_fft.*(f_filt(2)-f_filt(1)));
LPF_NP = 10*log10(filter_power*No/Eb_scalar^2);

% S = PSD(s,t,n/symbols_per_block,fs);
% R = PSD(r,t,n/symbols_per_block,fs);
% Y = PSD(y,t,n/symbols_per_block,fs);
% f_S = linspace(-fs/2,fs/2,length(S));
% 
% figure;
% subplot(3,1,1);
% plot(f_S,10*log10(S));
% title('case 2: RC and LPF');
% subplot(3,1,2);
% plot(f_S,10*log10(R));
% subplot(3,1,3);
% scatter(f_S,10*log10(Y),'.');
% title('y(t) Case 2 (EbNo = 10dB)');
% ylabel('power (dB)');
% xlabel('frequency');

%% 5. Detect the symbols a_hat[n] from the recieved signal y(t)
start = fix(length(RC)/2) + fix(length(LPF)/2)+1; % account for double filter delay
finish = length(t);
a_hat = zeros(1,length(a));
rbit_index = zeros(1,length(a));
sa = []; % sampled symbol values
j = 1; % a_hat index counter
for k = start:sps:finish
    % find constellation point with min distance to sample
    sa = [sa y(k)];
    [m, min_ind] = min(vecnorm(y(k)-symbols,2,1));
    rbit_index(j) = min_ind;
    a_hat(j) = symbols(min_ind);
    j = j+1;
end

%% 6. Compare the detected symbols a_hat[n] to the original symbols a[n]
% and caluculate the SER and BER (assuming Grey coding).
a = a(1:end-round(start/sps));
a_hat = a_hat(1:end-round(start/sps));
rbit_index = rbit_index(1:end-round(start/sps));
tbit_index = tbit_index(1:end-round(start/sps));
num_errors = nnz(a - a_hat);
ser = num_errors/(length(a));

% constellation plot for EbNo = 100 = 20dB
if EbNo == 100
    figure;
    constplot(symbols, sa);
    title(strcat('Constellation plot for RC filt and LPF; EbNo=',...
        num2str(EbNo)));
    xlabel('real');
    ylabel('imag');
end

% Calculate generic bit error rate given bitmap
num_bits = length(a)*log2(M);
tbits = bitmap(:,tbit_index);
rbits = bitmap(:,rbit_index);
num_errors = sum(abs(rbits-tbits),'all');
ber = num_errors/num_bits;

end

%% HELPER FUNCTIONS

% eyediagram(x,n): plots the eye diagram of signal x in active figure
% n: number of samples per trace
function eyediagram(x,n)
N = min(1000,fix(length(x)/n)); % number of traces to plot
hold on;
for k = 1:n:N*n
    plot(1:n, x(k:k+n-1))
end
hold off;
end

% constplot(sy, sa): constellation plot of samples sa and RX symbols sy
% sy: vector of symbol values
% sa: vector of sampled recieved values
function constplot(sy, sa)
hold on;
scatter(real(sa),imag(sa),10,'black','.');
scatter(real(sy),imag(sy),50,'red','x');
hold off;
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










