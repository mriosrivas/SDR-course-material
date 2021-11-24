% User tunable (samplesPerSymbol>=decimation)
samplesPerSymbol = 4; decimation = 4;
% Create a QPSK modulator System object and modulate data
qpskMod = comm.QPSKModulator('BitInput',true);
% Roll off factor
beta = 0.99 ;
% Set up filters
rctFilt = comm.RaisedCosineTransmitFilter( ...
    'OutputSamplesPerSymbol', samplesPerSymbol, ...
    'RolloffFactor', beta);
rcrFilt = comm.RaisedCosineReceiveFilter( ...
    'InputSamplesPerSymbol',  samplesPerSymbol, ...
    'DecimationFactor',       decimation);

% Generate, modulate, and tx filter data
data = randi([0 1],600,1);
modFiltData = rctFilt(qpskMod(data));
rxSig = awgn(modFiltData,27); % Add noise
rxFilt = rcrFilt(rxSig); % Rx filter

eyediagram(real(rxSig), 4);
ylim([-1.5, 1.5])
grid on
title('Transmit Eye Diagram');

eyediagram(real(rxFilt), 4);
ylim([-1.5, 1.5])
grid on
title('Receive Eye Diagram');
