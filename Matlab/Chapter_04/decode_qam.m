%----------------------------------------------------------------------
% Chapter 4
% "Digital Communication Systems Engineering Using Software Defined Radio
% MATLAB Scripts
%----------------------------------------------------------------------

% Clear workspace
clear all;

figNum = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Decoding QAM waveform using I/Q receiver

% Define parameters
N_samp = 1000; % Number of samples per symbol
N_symb = 10; % Number of symbols in transmission
cfreq = 1/10; % Carrier frequency of cosine and sine carriers

% Generate inphase and quadrature channels with 2-PAM waveforms
chI = 2*round(rand(1,N_symb))-1;
chQ = 2*round(rand(1,N_symb))-1;
samp_I = [];
samp_Q = [];
for ind = 1:1:N_symb,
    samp_I = [samp_I chI(ind)*ones(1,N_samp)];
    samp_Q = [samp_Q chQ(ind)*ones(1,N_samp)];
end;

% Apply cosine and sine carriers to inphase and quadrature components, sum
% waveforms together into composite transmission
tx_signal = samp_I.*cos(2.*pi.*cfreq.*(1:1:length(samp_I))) + samp_Q.*sin(2.*pi.*cfreq.*(1:1:length(samp_Q)));

% Separate out inphase and quadrature components from composite
% transmission
sig_I_unfilt = tx_signal.*cos(2.*pi.*cfreq.*(1:1:length(tx_signal)));
sig_Q_unfilt = tx_signal.*sin(2.*pi.*cfreq.*(1:1:length(tx_signal)));
lpf_coeffs = firls(11,[0 cfreq 1.05*cfreq 1],[1 1 0 0]); % Design lowpass filter to remove double frequency term
sig_I_filt = 2.*filter(lpf_coeffs,1,sig_I_unfilt);
sig_Q_filt = 2.*filter(lpf_coeffs,1,sig_Q_unfilt);


% Plot before + after inphase/quadrature signals regarding composite
% waveform creation
figure(figNum); figNum = figNum+1;
plot(0:1:(N_samp*N_symb-1),sig_I_filt,'r',0:1:(N_samp*N_symb-1),samp_I,'b');legend('Recovered','Original');
xlabel('Time (n)');ylabel('Amplitude');
%title('Inphase Signal Component');

figure(figNum); figNum = figNum+1;
plot(0:1:(N_samp*N_symb-1),sig_Q_filt,'r',0:1:(N_samp*N_symb-1),samp_Q,'b');legend('Recovered','Original');
xlabel('Time (n)');ylabel('Amplitude');
%title('Quadrature Signal Component');