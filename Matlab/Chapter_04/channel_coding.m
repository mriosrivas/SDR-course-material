%----------------------------------------------------------------------
% Chapter 4
% "Digital Communication Systems Engineering Using Software Defined Radio
% MATLAB Scripts
%----------------------------------------------------------------------

% Clear workspace
clear all;

figNum = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Protect data using simple repetition channel coding

% Define parameters
len = 100000; % Length of original binary data stream
N1 = 3; % First repetition factor; should be odd to avoid tie
N2 = 5; % Second repetition factor; should be odd to avoid tie
N3 = 7; % Third repetition factor; should be odd to avoid tie

% Generate binary data stream
bin_str = round(rand(1,len));

% Employ repetition code with repetition factors N1, N2, N3
chcode1_bin_str = zeros(1,N1*len);
chcode2_bin_str = zeros(1,N2*len);
chcode3_bin_str = zeros(1,N3*len);
for ind = 1:1:max([N1 N2 N3]),
    if (ind<=N1)
        chcode1_bin_str(ind:N1:(N1*(len-1)+ind))=bin_str;
    end;
    if (ind<=N2)
        chcode2_bin_str(ind:N2:(N2*(len-1)+ind))=bin_str;
    end;
    if (ind<=N3)
        chcode3_bin_str(ind:N3:(N3*(len-1)+ind))=bin_str;
    end;
end;

% Corrupt both binary strings with zero-mean unit variance Gaussian noise
% followed by rounding (creates "bit flipping" errors)
noisy_bin_str = bin_str + randn(1,len);
rx_bin_str0 = zeros(1,len);
ind0 = find(noisy_bin_str >= 0.5);
rx_bin_str0(ind0) = 1;
noisy_chcode1_bin_str = chcode1_bin_str + randn(1,N1*len);
rx_chcode1_bin_str = zeros(1,N1*len);
ind1 = find(noisy_chcode1_bin_str >= 0.5);
rx_chcode1_bin_str(ind1) = 1;
noisy_chcode2_bin_str = chcode2_bin_str + randn(1,N2*len);
rx_chcode2_bin_str = zeros(1,N2*len);
ind2 = find(noisy_chcode2_bin_str >= 0.5);
rx_chcode2_bin_str(ind2) = 1;
noisy_chcode3_bin_str = chcode3_bin_str + randn(1,N3*len);
rx_chcode3_bin_str = zeros(1,N3*len);
ind3 = find(noisy_chcode3_bin_str >= 0.5);
rx_chcode3_bin_str(ind3) = 1;

% Decode three encoded binary sequences
dec1_bin = (vec2mat(rx_chcode1_bin_str,N1)).';
dec2_bin = (vec2mat(rx_chcode2_bin_str,N2)).';
dec3_bin = (vec2mat(rx_chcode3_bin_str,N3)).';
ind11 = find(((sum(dec1_bin,1))/N1) >= 0.5);
ind12 = find(((sum(dec2_bin,1))/N2) >= 0.5);
ind13 = find(((sum(dec3_bin,1))/N3) >= 0.5);
rx_bin_str1 = zeros(1,len);
rx_bin_str1(ind11) = 1;
rx_bin_str2 = zeros(1,len);
rx_bin_str2(ind12) = 1;
rx_bin_str3 = zeros(1,len);
rx_bin_str3(ind13) = 1;

% Calculate bit error rate
ber0 = sum(abs(bin_str - rx_bin_str0))/len;
ber1 = sum(abs(bin_str - rx_bin_str1))/len;
ber2 = sum(abs(bin_str - rx_bin_str2))/len;
ber3 = sum(abs(bin_str - rx_bin_str3))/len;

% Plot sizes of original and encoded binary sequences
figure(figNum); figNum = figNum+1;

bar([ber0 ber1 ber2 ber3]);
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'None',sprintf('N=%d',N1),sprintf('N=%d',N2),sprintf('N=%d',N3)});
xlabel('Binary Transmission Sequences');
ylabel('Bit Error Rate');
%title('Impact of Repetition Coding on Binary Transmissions');

