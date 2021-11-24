clear all
% User tunable (samplesPerSymbol>=decimation)
samplesPerSymbol = 4;
% Create a QPSK modulator System object and modulate data
qpskMod = comm.QPSKModulator('BitInput',true);
% Set up filters
rctFilt = comm.RaisedCosineTransmitFilter('OutputSamplesPerSymbol', samplesPerSymbol);
% Generate, modulate, and tx filter data
data = randi([0 1],1000,1);
modFiltData = rctFilt(qpskMod(data));
% Plot results
freqz(data); hold on; freqz(modFiltData)
