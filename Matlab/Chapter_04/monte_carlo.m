%----------------------------------------------------------------------
% Chapter 4
% "Digital Communication Systems Engineering Using Software Defined Radio
% MATLAB Scripts
%----------------------------------------------------------------------

% Clear workspace
clear all;

figNum = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create "waterfall" curves for the bit error rate of a communication
% system via Monte Carlo

% Define parameters
len = 1000; % Length of individual data transmission
N_snr = 9; % Number of SNR values to evaluation
N_tx = 100; % Number of transmissions per SNR
nvar = [(10.^((1:1:N_snr)/10)).^(-1)]; % Noise variance values
% Noise can be obtained by using SNR = 10*log(S/N) where S=1

ber_data = zeros(N_snr,N_tx);
for ind = 1:1:N_snr, % Different SNR values
    for ind1 = 1:1:N_tx, % Different transmissions for same SNR value

        % Generate BPSK waveform (we will keep this the same for each
        % SNR value for now)
        tx_sig = 2*round(rand(1,len))-1;

        % Create additive noise
        noise_sig = sqrt(nvar(ind))*randn(1,len);

        % Create received (noisy) signal
        rx_sig = tx_sig + noise_sig;

        % Decode received signal back to binary
        decode_bin_str = zeros(1,len);
        decode_bin_str(find(rx_sig >= 0)) = 1;

        % Determine and store bit error rate
        ber_data(ind,ind1) = sum(abs(decode_bin_str - (tx_sig+1)/2))/len;
    end;
end;

% Calculate mean bit error rate and its standard deviation
mean_ber = mean(ber_data,2).';
std_ber = std(ber_data,'',2).';

% Plot bit error rate waterfall curve ... notice the divergence of standard
% deviation
figure(figNum); figNum = figNum+1;
semilogy(1:1:N_snr,mean_ber,'b-',1:1:N_snr,mean_ber-std_ber,'b--',1:1:N_snr,mean_ber+std_ber,'b-.');
xlabel('Signal to Noise Ratio (dB)');
ylabel('Probability of Error');
%title('Bit Error Rate - BPSK (Mean with Standard Deviation)');
legend('Mean','Mean - Std Dev','Mean + Std Dev');
