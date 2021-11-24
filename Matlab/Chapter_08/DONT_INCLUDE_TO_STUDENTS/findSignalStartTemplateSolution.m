%% Random seed for testing purposes
rng(123, 'twister')
%% General system details
sampleRateHz = 1e6; samplesPerSymbol = 8; numFrames = 1e2;
modulationOrder = 2;  filterSymbolSpan = 4;
barkerLength = 26; % Must be even
%% Impairments
snr = 20;
%% Generate symbols and Preamble
bits = randi([0 3], modulationOrder*1e3,1);
hBCode = comm.BarkerCode('Length',7,'SamplesPerFrame', barkerLength/2);
barker = hBCode()>0; frame=[barker;barker;bits];frameSize = length(frame);
% Modulate
modD = comm.DBPSKModulator(); bMod = clone(modD);
modulatedData = modD(frame>0);
%% Add TX/RX Filters
TxFlt = comm.RaisedCosineTransmitFilter(...
    'OutputSamplesPerSymbol', samplesPerSymbol,...
    'FilterSpanInSymbols', filterSymbolSpan);
RxFlt = comm.RaisedCosineReceiveFilter(...
    'InputSamplesPerSymbol', samplesPerSymbol,...snr
    'FilterSpanInSymbols', filterSymbolSpan,...
    'DecimationFactor', samplesPerSymbol);
RxFltRef = clone(RxFlt);
%% Setup visualization object(s)
hts1 = dsp.TimeScope('SampleRate', sampleRateHz,'TimeSpan', ...
    frameSize*2/sampleRateHz);
hAP = dsp.ArrayPlot;hAP.YLimits = [-3 35];
%% Demodulator
demod = comm.DBPSKDemodulator;
%% Model of error
BER = zeros(numFrames,1);PER = zeros(numFrames,1);
%     % Uncomment this for debug
%     diff = []
for k=1:numFrames
    % Insert random delay and append zeros
    delay = randi([0 frameSize-1-TxFlt.FilterSpanInSymbols]);
    delayedSignal = [zeros(delay,1); modulatedData;...
        zeros(frameSize-delay,1)];
    % Filter signal
    filteredTXDataDelayed = TxFlt(delayedSignal);
    % Pass through channel
    noisyData = awgn(filteredTXDataDelayed,snr,'measured');
    % Filter signal
    filteredData = RxFlt(noisyData);
    %filteredData = RxFlt(filteredTXDataDelayed);   

    %% Solution
    % Calculate correlation
    corr = xcorr(real(filteredData), [barker;barker]);
    
    % Moving average filter for Energy estimation  
    windowSize = 2*length(barker); 
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    u_ma = filter(b,a,abs(filteredData));
    energy = sum(u_ma);
    
    % Energy
    % energy = sum(abs(filteredData).^2);
    
    % Estimate number of zeros introduced
    sequenceLength = length([barker;barker]);
    numZeros = length(filteredData) - sequenceLength;
    
    % Limit correlation region    
    corrRegion = corr(numZeros:end-sequenceLength);
    
    % Decision rule (apply Ec. 8.14)
     thresholdRegion = corrRegion./energy;
%     normalThresholdRegion = normalize(thresholdRegion, 'range');
%    thresholdRegion = corrRegion./u_ma;
    normalThresholdRegion = normalize(thresholdRegion, 'range');
       
    findThresholdRegion = find(normalThresholdRegion>0.60);
    threshold = (findThresholdRegion(1) + 1) - filterSymbolSpan;
    
%  End of Solution
%%
    
    % Visualize Correlation
    %hts1(filteredData);pause(0.1);
    hts1(corrRegion);pause(0.1);
    % Remove offset and filter delay
    
%     % Uncomment this for debug
%     frameStart = delay + RxFlt.FilterSpanInSymbols + 1;
%     diff = [diff; threshold - frameStart]
    frameStart = threshold;
    frameHatNoPreamble = filteredData(frameStart:frameStart+frameSize-1);
    % Demodulate and check
    dataHat = demod(frameHatNoPreamble);
    demod.release(); % Reset reference
    % Correct BER calculation
    %BER(k) = mean((dataHat-frame));PER(k) = BER(k)>0;
    BER(k) = mean(abs(dataHat-(frame>0)));PER(k) = BER(k)>0;
end
% Result
fprintf('PER %2.2f\n',mean(PER));