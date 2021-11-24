%----------------------------------------------------------------------
% Chapter 4
% "Digital Communication Systems Engineering Using Software Defined Radio
% MATLAB Scripts
%----------------------------------------------------------------------

% Clear workspace
clear all;

figNum = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sending binary data via sinusoidal signal manipulation

% Parameters
sig_len = 1000; % Signal length (in samples)
sampl_per_bin = 100; % Samples per binary representation
bin_data_len = sig_len/sampl_per_bin; % Length of binary stream is a multiple of signal length
bin_data = round(rand(1,bin_data_len));

% Create sinusoidal carriers
sig_carrier_base = sin(2*pi*(0:(1/sampl_per_bin):(1-(1/sampl_per_bin)))); % Baseline carrier
sig_carrier_freq = sin(2*2*pi*(0:(1/sampl_per_bin):(1-(1/sampl_per_bin)))); % Double frequency
sig_carrier_phase = sin(2*pi*(0:(1/sampl_per_bin):(1-(1/sampl_per_bin)))+(pi/4)); % Phase shifted by 45 degrees

% Modulate sinusoidal carrier via amplitude, phase, and frequency
% manipulations
sig_bin = []; % Binary waveform
sig_ask = []; % Amplitude modulated
sig_psk = []; % Phase modulated
sig_fsk = []; % Frequency modulated
for ind = 1:1:bin_data_len,
    if (bin_data(ind)==1)
        sig_bin = [sig_bin ones(1,sampl_per_bin)];
        sig_ask = [sig_ask sig_carrier_base];
        sig_psk = [sig_psk sig_carrier_base];
        sig_fsk = [sig_fsk sig_carrier_base];
    else
        sig_bin = [sig_bin zeros(1,sampl_per_bin)];
        sig_ask = [sig_ask 0.5*sig_carrier_base];
        sig_psk = [sig_psk sig_carrier_phase];
        sig_fsk = [sig_fsk sig_carrier_freq];
    end;
end;

% Display all three representations
figure(figNum); figNum = figNum+1;
plot(0:1:(sig_len-1),sig_bin);axis([0 sig_len-1 -0.1 1.1]);xlabel('Time (n)');ylabel('Amplitude');
title('Binary Transmission');

figure(figNum); figNum = figNum+1;
plot(0:1:(sig_len-1),sig_ask);xlabel('Time (n)');ylabel('Amplitude');
title('Amplitude Shift Keying');

figure(figNum); figNum = figNum+1;
plot(0:1:(sig_len-1),sig_psk);xlabel('Time (n)');ylabel('Amplitude');
title('Phase Shift Keying');

figure(figNum); figNum = figNum+1;
plot(0:1:(sig_len-1),sig_fsk);xlabel('Time (n)');ylabel('Amplitude');
title('Frequency Shift Keying');
