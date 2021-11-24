%----------------------------------------------------------------------
% Chapter 4
% "Digital Communication Systems Engineering Using Software Defined Radio
% MATLAB Scripts
%----------------------------------------------------------------------

% Clear workspace
clear all;

figNum = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generating 4-level pulse amplitude modulation, quadrature amplitude modulation,
% and quadrature phase shift keying waveforms

% Define parameters
len = 10000; % Length of binary string
nvar = 0.250; % Noise variance

% Generate the random bit streams that have already been demultiplexed from
% a single high speed data stream
bin_str1 = round(rand(1,len)); % Inphase data stream
bin_str2 = round(rand(1,len)); % Quadrature data stream

% Perform mapping of binary streams to symbols
ind_wavefm = 2.*bin_str2 + 1.*bin_str1; % Create waveform indices
wavefm_4pam = zeros(1,len); % 4-PAM
wavefm_4qam = zeros(1,len); % 4-QAM
wavefm_qpsk = zeros(1,len); % QPSK
symb_4pam = [-3 -1 3 1];
symb_4qam = [-1+i 1+i -1-i 1-i];
symb_qpsk = [exp(i*(pi/5+pi/2)) exp(i*(pi/5+pi)) exp(i*(pi/5+0)) exp(i*(pi/5+3*pi/2)) ];
for ind = 1:1:4,
    wavefm_4pam(find(ind_wavefm == (ind-1))) = symb_4pam(ind);
    wavefm_4qam(find(ind_wavefm == (ind-1))) = symb_4qam(ind);
    wavefm_qpsk(find(ind_wavefm == (ind-1))) = symb_qpsk(ind);
end;

% Add complex zero-mean white Gaussian noise
noise_signal = (1/sqrt(2))*sqrt(nvar)*randn(1,len) + i*(1/sqrt(2))*sqrt(nvar)*randn(1,len);
rx_wavefm_4pam = wavefm_4pam + noise_signal;
rx_wavefm_4qam = wavefm_4qam + noise_signal;
rx_wavefm_qpsk = wavefm_qpsk + noise_signal;

%% Decode messages from previous example using Euclidean distance

% Go through every received waveform and determine Euclidean distance
% between received waveform and the available waveforms
eucl_dist_4pam = zeros(4,len);
eucl_dist_4qam = zeros(4,len);
eucl_dist_qpsk = zeros(4,len);
for ind = 1:1:4,
    eucl_dist_4pam(ind,1:1:len) = abs(symb_4pam(ind).*ones(1,len) - rx_wavefm_4pam);
    eucl_dist_4qam(ind,1:1:len) = abs(symb_4qam(ind).*ones(1,len) - rx_wavefm_4qam);
    eucl_dist_qpsk(ind,1:1:len) = abs(symb_qpsk(ind).*ones(1,len) - rx_wavefm_qpsk);
end;

% Select shortest Euclidean distances
[mdist_4pam,min_ind_4pam] = min(eucl_dist_4pam);
[mdist_4qam,min_ind_4qam] = min(eucl_dist_4qam);
[mdist_qpsk,min_ind_qpsk] = min(eucl_dist_qpsk);

% Decode into estimated binary streams
bin_str_est_4pam = dec2bin(min_ind_4pam-ones(1,len)).';
bin_str_est_4qam = dec2bin(min_ind_4qam-ones(1,len)).';
bin_str_est_qpsk = dec2bin(min_ind_qpsk-ones(1,len)).';

% Calculate bit error rate
ber_4pam = sum([abs((bin_str_est_4pam(1,:)-'0') - bin_str2) ...
	abs((bin_str_est_4pam(2,:)-'0') - bin_str1)])/(2*len);
ber_4qam = sum([abs((bin_str_est_4qam(1,:)-'0') - bin_str2) ...
	abs((bin_str_est_4qam(2,:)-'0') - bin_str1)])/(2*len);
ber_qpsk = sum([abs((bin_str_est_qpsk(1,:)-'0') - bin_str2) ...
	abs((bin_str_est_qpsk(2,:)-'0') - bin_str1)])/(2*len);

% Plot bit error rate results for three modulation schemes
figure(figNum); figNum = figNum+1;
bar([ber_4pam ber_4qam ber_qpsk]);
set(gca,'XTick',[1 2 3],'XTickLabel',{'4-PAM','4-QAM','QPSK'});
xlabel('Modulation Scheme');
ylabel('Bit Error Rate');
%title('Impact of Noise on Modulation Scheme Performance');