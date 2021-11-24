%----------------------------------------------------------------------
% Chapter 4
% "Digital Communication Systems Engineering Using Software Defined Radio
% MATLAB Scripts
%----------------------------------------------------------------------

% Clear workspace
clear all;

figNum = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Gram-Schmidt Orthogonalization and Vectorization

% Define parameters
N_samp = 1000; % Number of samples per time unit

% Create orthonormal basis functions
phi1 = [( 1/sqrt(3))*ones(1,N_samp) ...
	( 1/sqrt(3))*ones(1,N_samp) ...
	(-1/sqrt(3))*ones(1,N_samp)];
phi2 = [( 1/sqrt(6))*ones(1,N_samp) ...
	( 1/sqrt(6))*ones(1,N_samp) ...
	( 2/sqrt(6))*ones(1,N_samp)];
phi3 = [0*ones(1,N_samp) 0*ones(1,N_samp) 0*ones(1,N_samp)];
phi4 = [( 1/sqrt(2))*ones(1,N_samp) ...
	(-1/sqrt(2))*ones(1,N_samp) ...
	  0*ones(1,N_samp)];

% Based on these orthonormal basis functions, create the four symbol waveforms
sig_s1 = (2/sqrt(3))*phi1 + (sqrt(6)/3)*phi2 + 0*phi3 + 0*phi4;
sig_s2 = 0*phi1 + 0*phi2 + 0*phi3 + sqrt(2)*phi4;
sig_s3 = (sqrt(3))*phi1 + 0*phi2 + 0*phi3 + 0*phi4;
sig_s4 = (-1/sqrt(3))*phi1 + (-4/sqrt(6))*phi2 + 0*phi3 + 0*phi4;

% Plot resulting signal waveforms and compare
figure(figNum); figNum = figNum+1;
plot(0:(1/N_samp):(3-(1/N_samp)),sig_s1,'b');xlabel('Time (n)');ylabel('Amplitude');
%title('s_1(n)');
axis([0 3.5 -1.5 1.5]);

figure(figNum); figNum = figNum+1;
plot(0:(1/N_samp):(3-(1/N_samp)),sig_s2,'b');xlabel('Time (n)');ylabel('Amplitude');
%title('s_2(n)');
axis([0 3.5 -1.5 1.5]);

figure(figNum); figNum = figNum+1;
plot(0:(1/N_samp):(3-(1/N_samp)),sig_s3,'b');xlabel('Time (n)');ylabel('Amplitude');
%title('s_3(n)');
axis([0 3.5 -1.5 1.5]);

figure(figNum); figNum = figNum+1;
plot(0:(1/N_samp):(3-(1/N_samp)),sig_s4,'b');xlabel('Time (n)');ylabel('Amplitude');
%title('s_4(n)');
axis([0 3.5 -1.5 1.5]);