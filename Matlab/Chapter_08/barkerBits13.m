% Show Barker Autocorrelations search example
rng('default')

% Barker code
sequenceLength = 13;
hBCode = comm.BarkerCode('Length',13,'SamplesPerFrame', sequenceLength);
seq = hBCode();

% Recived signal
gapLen = 100; gapLenEnd = 200;
gen = @(Len) 2*randi([0 1],Len,1)-1;
y = [gen(gapLen); seq; gen(gapLenEnd)];%Lr = length(y)

% Cross-correlation
corr = xcorr(y,seq); %Order does matters!!!

% Length of received signal
Lr = length(y);
% Length of Barker code
La =  length(seq);
% Length of appended zeros to a[n]
L_zeros = Lr - La;
% Length of cross-correlation (estimated)
L_xcorr = 2*Lr-1;
% Length of cross-correlation (calculated)
L_xcorr_calc = length(corr);

% Estimated offset position p
[~,arg_max_xcorr] = max(corr);
p_hat = arg_max_xcorr - Lr;

% Calculated offset position p
p = gapLen;

% Estimated start of frame
start_hat = p_hat + La;
% Calculated start of frame
start = p + sequenceLength;

figure(1);
stem(corr)
grid('on')
title('Cross Correlation')

figure(2);
stem(y)
axis([0, length(y), -2, 2]);
grid('on')
title('Received Signal')