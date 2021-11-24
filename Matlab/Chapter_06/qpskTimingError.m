%% Correct QPSK Signal for Timing Error
% Correct for a fixed symbol timing error on a noisy QPSK signal.
% Create raised cosine transmit and receive filter System objects™.

% Samples per symbol N
N = 4;
txfilter = comm.RaisedCosineTransmitFilter( ...
    'OutputSamplesPerSymbol',N);
rxfilter = comm.RaisedCosineReceiveFilter( ...
    'InputSamplesPerSymbol',N, ...
    'DecimationFactor',2);

% Create a delay object to introduce a fixed timing error.
variableDelay = dsp.VariableFractionalDelay;

%Create a SymbolSynchronizer object to eliminate the timing error.
symbolSync = comm.SymbolSynchronizer;

%Generate random 4-ary symbols and apply QPSK modulation.
data = randi([0 3],5000,1);
modSig = pskmod(data,4,pi/4);

%Filter the modulated signal through a raised cosine transmit filter and apply a fixed delay.
txSig = txfilter(modSig);      
delaySig = variableDelay(txSig, 0.3*N);

%Pass the delayed signal through an AWGN channel with a 15 dB signal-to-noise ratio.
rxSig = awgn(delaySig,15,'measured');

%Filter the received signal and display its scatter plot. The scatter plot shows that the received signal does not align with the expected QPSK reference constellation due to the timing error.
rxSample = rxfilter(rxSig);  
scatterplot(rxSample(1001:end),2)

%Correct for the symbol timing error by using the symbol synchronizer object. Display the scatter plot and observe that the synchronized signal now aligns with the expected QPSK constellation.
rxSync = symbolSync(rxSample);
scatterplot(rxSync(1001:end),2)

