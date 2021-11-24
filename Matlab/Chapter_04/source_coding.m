%----------------------------------------------------------------------
% Chapter 4
% "Digital Communication Systems Engineering Using Software Defined Radio
% MATLAB Scripts
%----------------------------------------------------------------------

% Clear workspace
clear all;

figNum = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reducing amount of data transmission using source coding

% Define parameters
len = 10000; % Length of binary data stream

% Have two binary sources, one 50/50 and the other 90/10 in terms of ones
% and zeros
bin1 = round(rand(1,len)); % 50/50 binary
bin2 = round(0.5*rand(1,len)+0.45); %90/10 binary

% Encode strings of ones in terms of the length of these strings
enc_bin1 = [];
enc_bin2 = [];
for ind = 1:1:len,
    if (bin1(ind) == 1)  % Encoding 50/50
        if (ind == 1)
            enc_bin1 = 1;
        else
            enc_bin1(end) = enc_bin1(end)+1;
        end;
    else
        enc_bin1 = [enc_bin1 0];
    end;
    if (bin2(ind) == 1)  % Encoding 90/10
        if (ind == 1)
            enc_bin2 = 1;
        else
            enc_bin2(end) = enc_bin2(end)+1;
        end;
    else
        enc_bin2 = [enc_bin2 0];
    end;
end;

% Find size of encoded binary streams
% (assume all one string length values possess the same number of bits)
ind1 = find(enc_bin1 ~= 0);
ind2 = find(enc_bin2 ~= 0);
[largest_ebin1,ind_largest_ebin1] = max(enc_bin1(ind1));
[largest_ebin2,ind_largest_ebin2] = max(enc_bin2(ind2));
numbits1 = length(dec2bin(largest_ebin1)-'0');
numbits2 = length(dec2bin(largest_ebin2)-'0');
total_size_ebin1 = length(ind1)*numbits1 + length(find(enc_bin1 == 0)); %Encoded ones*bit_header + zeros
total_size_ebin2 = length(ind2)*numbits2 + length(find(enc_bin2 == 0)); %Encoded ones*bit_header + zeros

% Plot sizes of original and encoded binary sequences
figure(figNum); figNum = figNum+1;
bar([len total_size_ebin1 total_size_ebin2]);
set(gca,'XTick',[1 2 3],'XTickLabel',{'Original','Encoded (50/50)','Encoded (90/10)'});
xlabel('Binary Transmission Sequences');
ylabel('Number of Bits');
%title('Impact of Source Coding on Binary Transmissions');

