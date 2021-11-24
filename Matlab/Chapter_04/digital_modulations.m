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
nvar = 0.1250; % Noise variance

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

% Generate scatter plots of signal constellations
figure(figNum); figNum = figNum+1;
plot(real(rx_wavefm_4pam),imag(rx_wavefm_4pam),'bo',real(wavefm_4pam),imag(wavefm_4pam),'rx');axis([-4 4 -1 1]);
xlabel('Inphase');ylabel('Quadrature');
title('PAM');

figure(figNum); figNum = figNum+1;
plot(real(rx_wavefm_4qam),imag(rx_wavefm_4qam),'bo',real(wavefm_4qam),imag(wavefm_4qam),'rx');axis([-1.5 1.5 -1.5 1.5]);
xlabel('Inphase');ylabel('Quadrature');
title('QAM');


figure(figNum); figNum = figNum+1;
plot(real(rx_wavefm_qpsk),imag(rx_wavefm_qpsk),'bo',real(wavefm_qpsk),imag(wavefm_qpsk),'rx');axis([-1.5 1.5 -1.5 1.5]);
xlabel('Inphase');ylabel('Quadrature');
title('QPSK');
