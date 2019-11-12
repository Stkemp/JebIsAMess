% ECE251 Assignment 6: Differential Encoding
% Written by Stephen Kemp, 11/09/19

clear all;
close all;
clc;

M = 4;
gamma = sqrt(3/2*log2(M)/(M-1)); 
ber = [];
ser = [];
EbNo_dB = [-10:1:20];
delt_f = [0 1 10 100];
EbNo = 10.^(EbNo_dB./10);
P_E = (2*(1-1/sqrt(M))*erfc(gamma*sqrt(EbNo)));% Theoretical symbol error
ber_theo = P_E/log2(M);
row = 1;
% Run simulation
for j = delt_f
    for k = EbNo
        [b,s] = differential4QAM_error_rate_simulation(k, j);
        ser = [ser s];
    end
end
ser = reshape(ser,length(EbNo_dB),length(delt_f)).';
%% Plot simulated and theorectial data:
figure;
for j = 1:length(delt_f)
    subplot(length(delt_f),1,j);
    semilogy(EbNo_dB, ser(j,:), EbNo_dB, P_E);
    ylim([1E-5,1])
    legend('simulated differential 4QAM', 'theoretical 4QAM');
    title(strcat('SER vs. EbNo for freq offset = ',num2str(delt_f(j))));
    ylabel('Symbol Error Rate');
    xlabel('EbNo (dB)');
end

function [ber, ser] = differential4QAM_error_rate_simulation(EbNo, delt_f)
%% SIMULATION PARAMS
fsym = 1000; % symbol frequency
fc = 3000; % carrier frequency
sps = 16; % number of samples/symbol
n = 50000; % number of 3-bit 4QAM symbols
symbols_per_block = 50; % sets symbols/block when calculating PSD
No = 1; % base noise power level
alpha = .1; % excess SRRC bandwidth
span = 16; % number of symbols spanned by filter
symbols = [pi/4,3*pi/4,5*pi/4,7*pi/4]; % differential 4QAM symbol list
bitmap = [1,1; 1,0; 0,0; 0,1]'; % gray coding bitmap
% symbols_per_block = 50; % sets symbols/block when calculating PSD

%% SIMULATION INIT
M = length(symbols); % number of combinations of bits
fs = sps*fsym;
Tsym = 1/fsym; % symbol pulse duration
Ts = 1/fs;
t = [0:Ts:Tsym*n];
t = t(1:end-1); % cut off element

%% SIMULATION OF SIGNAL PATH
tbit_index = randi([1,length(symbols)],[1,n]); % generate symbol indexes
a = symbols(tbit_index); % map symbols from indexes
c = exp(i.*cumsum([0 a(1:end-1)])); % differentially encode symbols
c_up = reshape([c;zeros(sps-1,length(c))], 1, []); % upsample a[n]

% calculate signal scalar for calibration to desired EbNo
Eb_desired = EbNo*No;
Eb = mean(abs(c).^2)/log2(M);
Eb_scalar = sqrt(Eb_desired/Eb); 

SRRC = rcosdesign(alpha,span,sps,'sqrt'); % SRRC filter
s = filter(SRRC,1,c_up); % generate baseband signal s(t)

x = real(s.*exp(i*2*pi*fc.*t)); % passband signal

variance = No/4;
stddev = sqrt(variance);
noise = randn(1,length(t))*stddev./Eb_scalar; % real passband noise
x_n = x + noise; % add Gaussian noise to signal

% demodulate using imperfect local oscillator
r = hilbert(x_n).*exp(-i*2*pi*(fc + delt_f)*t);

%Pass the signal r(t) through an SRRC recieve filter to get y(t)
y = filter(SRRC,1,r);

%% SAMPLE SIGNAL AND CALCULATE SER/BER
start = length(SRRC); % account for double filter delay
finish = length(t);
samples = y(start:sps:finish);
diff_samples = diff(angle(samples));
neg_indeces = find(diff_samples<0);
% circularly rectify negative values
diff_samples(neg_indeces) = diff_samples(neg_indeces) + 2*pi;
% find constellation points with min distance to samples
[m, rbit_index] = min(abs(repmat(diff_samples,M,1)-symbols.')); 
a_hat = symbols(rbit_index);

% Calculate SER
a = a(1:end-span-1); % disregard symbols pushed out from filter delay
a_hat = a_hat(1:end);
tbit_index = tbit_index(1:end-span-1);% symbols pushed out from filter delay
rbit_index = rbit_index(1:end);
num_errors = nnz(a - a_hat);
ser = num_errors/(length(a));

% Calculate generic bit error rate for given bitmap
num_bits = length(a)*log2(M);
tbits = bitmap(:,tbit_index);
rbits = bitmap(:,rbit_index);
num_errors = sum(abs(rbits-tbits),'all');
ber = num_errors/num_bits;

% if EbNo == 100
%     % time plots
%     figure;
%     subplot(6,1,1);
%     plot(t(1:1000),abs(c_up(1:1000)));
%     subplot(6,1,2);
%     plot(t(1:1000),s(1:1000));
%     subplot(6,1,3);
%     plot(t(1:1000),x(1:1000));
%     subplot(6,1,4);
%     plot(t(1:1000),x_n(1:1000));
%     subplot(6,1,5);
%     plot(t(1:1000),r(1:1000));
%     subplot(6,1,6);
%     plot(t(1:1000),y(1:1000));
% 
% 
%     % PSD plots
%     figure;
%     subplot(6,1,1);
%     C_up = PSD(c_up,t,n/symbols_per_block,fs);
%     f = linspace(-fs/2,fs/2,length(C_up));
%     plot(f,10*log10(C_up));
%     subplot(6,1,2);
%     S = PSD(s,t,n/symbols_per_block,fs);
%     plot(f,10*log10(S));
%     subplot(6,1,3);
%     X = PSD(x,t,n/symbols_per_block,fs);
%     plot(f,10*log10(X));
%     subplot(6,1,4);
%     X_n = PSD(x_n,t,n/symbols_per_block,fs);
%     plot(f,10*log10(X_n));
%     subplot(6,1,5);
%     R = PSD(r,t,n/symbols_per_block,fs);
%     plot(f,10*log10(R));
%     subplot(6,1,6);
%     Y = PSD(y,t,n/symbols_per_block,fs);
%     plot(f,10*log10(Y));
% end

end

%% HELPER FUNCTIONS

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