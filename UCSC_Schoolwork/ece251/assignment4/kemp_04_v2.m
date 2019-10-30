% ECE251 Assignment 3: 4-QAM Error Rate vs SNR Evaluation
% Written by Stephen Kemp, 10/24/19

clear all;
close all;
clc;

%% 7. Generate BER/SER values for Eb/No = 0:2:20
% Calculate power efficiency gamma for P[E]
M = 4;
gamma = sqrt(3/2*log2(M)/(M-1));
ber = [];
ser = [];
P_E = [];
EbNo_dB = [];
EbNo = [];
% Run simulation
for k = 0:1:20
    EbNo_dB = [EbNo_dB k];
    EbNo = [EbNo 10^(k/10)];
    [b,s] = error_rate_simulation(10^(k/10));
    ber = [ber b];
    ser = [ser s];
    % Theoretic probability of symbol error
    P_E = [P_E (2*(1-1/sqrt(M))*erfc(gamma*sqrt(10^(k/10))))];
end

ber_theo = P_E/log2(M);
SNR = EbNo*log2(M);
SNR_dB = 10*log10(SNR);

%% 8. Plot the following simulated AND theorectial data:
% SER vs. Eb/No
% BER vs. Eb/No
% SER vs. SNR
% BER vs. SNR

figure(1);
subplot(2,1,1);
semilogy(EbNo_dB, ser, EbNo_dB, P_E);
ylim([1E-5,1])
legend('simulated', 'theoretical');
title('Symbol Error Rate vs. EbNo');
ylabel('Symbol Error Rate');
xlabel('EbNo (dB)');

subplot(2,1,2);
semilogy(EbNo_dB, ber, EbNo_dB, ber_theo);
ylim([1E-5,1])
legend('simulated', 'theoretical');
title('Bit Error Rate vs. EbNo');
ylabel('Bit Error Rate');
xlabel('EbNo (dB)');

figure(2);
subplot(2,1,1);
semilogy(SNR_dB, ser, SNR_dB, P_E);
ylim([1E-5,1])
legend('simulated', 'theoretical');
title('Symbol Error Rate vs. SNR');
ylabel('Symbol Error Rate');
xlabel('SNR (dB)');

subplot(2,1,2);
semilogy(SNR_dB, ber, SNR_dB, ber_theo);
ylim([1E-5,1])
legend('simulated', 'theoretical');
title('Bit Error Rate vs. SNR');
ylabel('Bit Error Rate');
xlabel('SNR (dB)');

function [ber, ser] = error_rate_simulation(EbNo)
%% 1. Generate a random sequence a[n] of 4-QAM symbols at 1000 symbol/sec
fsym = 1000;
sps = 8; % number of samples/symbol
fs = sps*fsym;
n = 1000000; % number of 2-bit 4QAM symbols
symbols_per_block = 50; % sets symbols/block when calculating PSD

Tsym = 1/fsym; % symbol pulse duration
Ts = 1/fs;
N = Tsym*n; % total time
t = [0:Ts:N];
t = t(1:end-1); % cut off element

a = 2.*randi([0,1],[1,n])-1 + 2*i.*randi([0,1],[1,n])-i; %generate symbols
a_up = reshape([a;zeros(sps-1,length(a))], 1, []); %upsample a[n]


%% 2. Pass a[n] through a SRRC TX filter with excess bandwidth of 10% to
% get the TX baseband signal s(t). Scale the signal so as to get the signal
% power P according to the specified SNR or Eb/No
No = 1;
alpha = .1; % 10% excess bandwidth
span = 16; % number of symbols spanned by filter

Eb_desired = EbNo*No;
Es = mean(abs([-i,-1,1,i]).^2);
Eb = Es*log2(4);
Eb_scalar = sqrt(Eb_desired/Eb); %sqrt because Eb_des/Eb is a power conversion and we want magnitude scalar;

SRRC = rcosdesign(alpha,span,sps,'sqrt'); % generate SRRC filter
s = filter(SRRC,1,a_up).*Eb_scalar;



%% 3. Add complex white Gaussian noise n(t) with variance No/2 to the
% baseband signal to get r(t) = s(t) + n(t)
variance = No/2;
stddev = sqrt(variance/2);
%default normal std dev = 1, so have to scale it.
re = randn(1,length(t))*stddev; %generate real white noise
im = randn(1,length(t))*stddev; %generate imaginary white noise
n = re + i.*im;

r = s + n; % add Gaussian noise to signal

%% 4. Pass the signal r(t) through an SRRC recieve filter to get y(t)
y = filter(SRRC,1,r)./Eb_scalar;

% figure;
% eyediagram(real(y),sps*2);
% title(strcat('eye plot for EbNo = ', num2str(EbNo)));

%% 5. Detect the symbols a_hat[n] from the recieved signal y(t)
start = length(SRRC); % account for double filter delay
finish = length(t);
a_hat = zeros(1,length(a));
j = 1; % a_hat index counter
for k = start:sps:finish
    % thresholds based on eye diagram
    if real(y(k)) >= 0 & imag(y(k)) >= 0
        a_hat(j) = 1+i;
    elseif real(y(k)) >= 0 & imag(y(k)) < 0
        a_hat(j) = 1-i;
    elseif real(y(k)) < 0 & imag(y(k)) >= 0
        a_hat(j) = -1+i;
    else
        a_hat(j) = -1-i;
    end
    j = j+1;
end

%% 6. Compare the detected symbols a_hat[n] to the original symbols a[n]
% and caluculate the SER and BER (assuming Grey coding).
a = a(1:end-span);
a_hat = a_hat(1:end-span);
num_errors = nnz(a - a_hat);
ser = num_errors/(length(a));

% Calculate bit error rate assuming grey coding for 4QAM
num_bits = length(a)*log2(4);
num_errors = sum((abs(real(a-a_hat)) + abs(imag(a-a_hat)))/2);
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










