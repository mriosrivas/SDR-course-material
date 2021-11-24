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


%% Correlator-based receiver implementation using Gram-Schmidt example
% previous demonstrated

% Define parameters
N_symb = 10; % Number of symbols contained within intercepted signal

% Randomly generate intercepted waveform consisting of s1(n), s2(n), s3(n), and s4(n)
rx_sig = [];
orig_msg = [];
for ind = 1:1:N_symb,
    rnd_val = rand(1,1);
    if (rnd_val < 0.25) % Add s1(n) waveform
        rx_sig = [rx_sig sig_s1];
        orig_msg = [orig_msg 1];
    elseif ((rnd_val >= 0.25)&&(rnd_val < 0.5)) % Add s2(n) waveform
        rx_sig = [rx_sig sig_s2];
        orig_msg = [orig_msg 2];
    elseif ((rnd_val >= 0.5)&&(rnd_val < 0.75)) % Add s3(n) waveform
        rx_sig = [rx_sig sig_s3];
        orig_msg = [orig_msg 3];
    else % Add s4(n) waveform
        rx_sig = [rx_sig sig_s4];
        orig_msg = [orig_msg 4];
    end;
end;

% Vectorize the intercepted signal
dim1_comp = [];
dim2_comp = [];
dim4_comp = [];
for ind = 1:1:N_symb,
    dim1_comp = [dim1_comp sum(rx_sig(((ind-1)*3*N_samp+1):1:(ind*3*N_samp)).*phi1)];
    dim2_comp = [dim2_comp sum(rx_sig(((ind-1)*3*N_samp+1):1:(ind*3*N_samp)).*phi2)];
    dim4_comp = [dim4_comp sum(rx_sig(((ind-1)*3*N_samp+1):1:(ind*3*N_samp)).*phi4)];
end;
dim1_comp = dim1_comp/N_samp;
dim2_comp = dim2_comp/N_samp;
dim4_comp = dim4_comp/N_samp;

% Using the correlator receiver approach, we determine the closest symbol
% vector to each vectorized waveform based on Euclidean distance
s1vec = [(2/sqrt(3)) (sqrt(6)/3) 0 0];
s2vec = [0 0 0 sqrt(2)];
s3vec = [(sqrt(3)) 0 0 0];
s4vec = [(-1/sqrt(3)) (-4/sqrt(6)) 0 0];
est_msg = [];
for ind = 1:1:N_symb,
    [val,symb_ind] = min([ ...
        sum((s1vec - [dim1_comp(ind) dim2_comp(ind) 0 dim4_comp(ind)]).^2) ...
        sum((s2vec - [dim1_comp(ind) dim2_comp(ind) 0 dim4_comp(ind)]).^2) ...
        sum((s3vec - [dim1_comp(ind) dim2_comp(ind) 0 dim4_comp(ind)]).^2) ...
        sum((s4vec - [dim1_comp(ind) dim2_comp(ind) 0 dim4_comp(ind)]).^2) ...
        ]);
    est_msg = [est_msg symb_ind];
end;

% Plot original message and recovered message after intercepted signal was
% vectorized and correlated with available message vectors
figure(figNum); figNum = figNum+1;
stem(0:1:(N_symb-1),orig_msg,'bo');hold on;
stem(0:1:(N_symb-1),est_msg,'rx');
xlabel('Time (n)');ylabel('Message Index');
%title('Matching Correlator Receiver Output with Original Transmission');
legend('Original','Recovered');axis([0 N_symb-1 0 4.5]);
hold off;
