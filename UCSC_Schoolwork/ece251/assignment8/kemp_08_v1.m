% ECE251 Assignment 8: OFDM Channel Estimation
% Written by Stephen Kemp, 11/21/19

clear all;
close all;
clc;

M = 4;
num_blocks = 128;
gamma = sqrt(3/2*log2(M)/(M-1));
ser = [];
avg_channel_ser = [];
channels = [[1 0 0 -.7 0 0]; [1 0 0 0 0 -.7]];
estimation = ["single", "average"];
EbNo_dB = [0:2:20];
EbNo = 10.^(EbNo_dB./10);
P_E = (2*(1-1/sqrt(M))*erfc(gamma*sqrt(EbNo))); % Theoretical symbol error

% calculate and average channel SERs
for j = channels.'
    channel_energy = abs(fft(j.',num_blocks)).^2;
    channel_EbNo = repmat(channel_energy.',1,length(EbNo))...
        .*repmat(EbNo,num_blocks,1);
    channel_ser = (2*(1-1/sqrt(M))*erfc(gamma.*sqrt(channel_EbNo)));
    avg_channel_ser = [avg_channel_ser; mean(channel_ser)];
end

row = 1;
% Run simulation
for p = estimation
    for j = channels.'
        for k = EbNo
            s = blind_OFDM_error_rate_simulation(k, j.', p);
            ser = [ser s];
        end
    end
end
ser = reshape(ser,length(EbNo),size(channels,1)+length(estimation).').';
%% Plot simulated and theorectial data:
for p = 1:length(estimation)
    figure;
    for j = 1:size(channels,1)
        subplot(2,1,j);
        semilogy(EbNo_dB, ser(p+j,:), EbNo_dB, avg_channel_ser(j,:));
        ylim([1E-5,1])
        legend('simulated', 'theoretical');
        title(strcat('SER vs. EbNo for channel = '...
            ,mat2str(channels(j,:).')...
            ,'and estimation type = ', estimation(p)));
        ylabel('Symbol Error Rate');
        xlabel('EbNo (dB)');
    end
end

% blind_OFDM_error_rate_simulation(EbNo, h, estimation)
% params:
%   -EbNo: desired Eb/No ratio for the simulation
%   -h: channel frequency response
%   -estimation: type of channel estimation algorithm
%       "single": Estimate channel from pilots in a single ODFM symbol
%       "average": Estimate channel using averaged results from all pilots
function ser = blind_OFDM_error_rate_simulation(EbNo, h, estimation)
%% SIMULATION PARAMS
fsym = 1000000; % symbol frequency
sps = 1; % number of samples/symbol
block_size = 129;
pilot_freq = 8; % number of samples per pilot 
num_blocks = 300;
n = num_blocks*block_size; % number of 4QAM symbols
pre_len = 28; % cyclic prefix length
No = 1; % base noise power level
symbols = [1+i,1-i,-1-i,-1+i]; % differential 4QAM symbol list
bitmap = [1,1; 1,0; 0,0; 0,1].'; % gray coding bitmap

%% SIMULATION INIT
M = length(symbols); % number of combinations of bits
fs = sps*fsym;
Tsym = 1/fsym; % symbol pulse duration
Ts = 1/fs;
t = [0:Ts:Tsym*n];
t = t(1:end-1); % cut off element

%% SIMULATION OF SIGNAL PATH
% generate OFDM baseband signal
tbit_index = randi([1,length(symbols)],[1,n]); % generate symbol indexes
a = symbols(tbit_index); % map symbols from indexes
% TODO: collect pilot symbol
b = reshape(a,block_size,num_blocks); % create blocks (S->P)
pilots = b(1:pilot_freq:end,:); % sample pilots from symbols
b_i = ifft(b); % columnwise idft of blocks
b_i_pre = [b_i(end-pre_len+1:end,:) ; b_i]; % prepend cyclical prefix
s = reshape(b_i_pre,1,prod(size(b_i_pre))); % create baseband signal (P->S)

s_hat = filter(h,1,s); % filter signal through the channel

% calculate signal scalar for calibration to desired EbNo
Eb_desired = EbNo*No;
Eb = var(s)/log2(M);
Eb_scalar = sqrt(Eb_desired/Eb);

variance = No/2;
stddev = sqrt(variance);
re = randn(1,length(s_hat))*stddev; %generate real white noise
im = randn(1,length(s_hat))*stddev; %generate imaginary white noise
noise = (re + i.*im)./Eb_scalar; % scale the noise to acheive desired EbNo
s_n = s_hat + noise; % add Gaussian noise to signal

b_i_pre_hat = reshape(s_n, block_size+pre_len, num_blocks); % P->S
b_i_hat = b_i_pre_hat(pre_len+1:end,:); % Discard prefix
b_hat = fft(b_i_hat); % col-wise dft
pilots_hat = b_hat(1:pilot_freq:end,:); % recieved pilot symbols

% interpolate each OFDM symbol's estimated channel response
eq = [];
for k = 1:num_blocks
    nextr = interp1(1:pilot_freq:block_size,...
        real(pilots_hat(:,k))./real(pilots(:,k)), 1:block_size, 'pchip');
    nexti = interp1(1:pilot_freq:block_size,...
        imag(pilots_hat(:,k))./imag(pilots(:,k)), 1:block_size, 'pchip');
    eq = [eq nextr.'+i.*nexti.'];
end

if strcmp(estimation, "single")
    % plot all responses and true response (magnitude and phase)
    if EbNo == 100
        figure;
        subplot(2,1,1);
        hold on;
        f = linspace(-fs/2,fs/2,block_size);
        plot(repmat(f.',1,num_blocks),fftshift(abs(eq)));
        plot(f, abs(fftshift(fft(h,block_size))),':','LineWidth',2); %ideal response
        title(strcat("Magnitude Response of Channel for EbNo = "...
            ,num2str(EbNo), " and channel = ", mat2str(h)));
        ylabel('Response Magnitude (V)');
        xlabel('Frequency (Hz)');
        legend('Estimated','Ideal');
        hold off;
        subplot(2,1,2);
        hold on;
        plot(repmat(f.',1,num_blocks),fftshift(angle(eq)));
        plot(f, angle(fftshift(fft(h,block_size))),':','LineWidth',2); %ideal response
        title(strcat("Phase Response of Channel for EbNo = "...
            ,num2str(EbNo), " and channel = ", mat2str(h)));
        ylabel('Response Phase (Radians)');
        xlabel('Frequency (Hz)');
        legend('Estimated','Ideal');
        hold off;
    end
elseif strcmp(estimation, "average")  
    % average channel responses (may have to do interp after averaging)
    channel_avgs = mean(eq.').';
    eq = repmat(channel_avgs,1,num_blocks);
    
    % plot avgd response and true response (magnitude and phase)
    if EbNo == 100
        figure;
        subplot(2,1,1);
        hold on;
        f = linspace(-fs/2,fs/2,block_size);
        plot(f,fftshift(abs(channel_avgs.')));
        plot(f,abs(fftshift(fft(h,block_size))));
        title(strcat("Average Magnitude Response of Channel for EbNo = "...
            ,num2str(EbNo), " and channel = ", mat2str(h)));
        ylabel('Response Magnitude (V)');
        xlabel('Frequency (Hz)');
        legend('Estimated','Ideal');
        hold off;
        subplot(2,1,2);
        hold on;
        plot(f,fftshift(angle(channel_avgs.')));
        plot(f,angle(fftshift(fft(h,block_size))));
        title(strcat("Average Phase Response of Channel for EbNo = "...
            ,num2str(EbNo), " and channel = ", mat2str(h)));
        ylabel('Response Phase (Radians)');
        xlabel('Frequency (Hz)');
        legend('Estimated','Ideal');
        hold off;
    end
else
    error("estimation parameter must be ''single'' or ''average''");
end

y = reshape(b_hat./eq,[1,prod(size(b_hat))]); %equalize

%% SAMPLE SIGNAL AND CALCULATE SER/BER
start = 1; % account for double filter delay
finish = length(t);
samples = y(start:sps:finish);
% find constellation points with min distance to samples
[m, rbit_index] = min(abs(repmat(samples,M,1)-symbols.')); 
a_hat = symbols(rbit_index);

% Calculate SER
num_errors = nnz(a - a_hat);
ser = num_errors/(length(a));

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