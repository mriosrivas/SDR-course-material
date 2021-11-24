clear all; close all;
%% General system details
sampleRateHz = 1e6; samplesPerSymbol = 1; frameSize = 2^10;
numFrames = 10; numSamples = numFrames*frameSize;
DampingFactors = [3,1.3];
NormalizedLoopBandwidths = [0.03,0.24];
%% Generate symbols
order = 4; data = pskmod(randi([0 order-1], numSamples, 1),order,0); % QPSK
%% Configure LF and PI
LoopFilter = dsp.IIRFilter('Structure', 'Direct form II transposed', 'Numerator', [1 0], 'Denominator', [1 -1]);
Integrator = dsp.IIRFilter('Structure', 'Direct form II transposed', 'Numerator', [0 1], 'Denominator', [1 -1]);

phErrs = zeros(numSamples,2);
index = 1;
PhaseAcc = zeros(numSamples,2);
for NormalizedLoopBandwidth = NormalizedLoopBandwidths
    DampingFactor = 1.3;
%for DampingFactor = DampingFactors
    %% Calculate range estimates
    NormalizedPullInRange = min(1, 2*pi*sqrt(2)*DampingFactor*NormalizedLoopBandwidth)
    MaxFrequencyLockDelay = (4*NormalizedPullInRange^2)/(NormalizedLoopBandwidth)^3
    MaxPhaseLockDelay = 1.3/(NormalizedLoopBandwidth)
    %% Impairments
    snr = 25;
    frequencyOffsetHz = sampleRateHz*0.02;%(NormalizedPullInRange);
    noisyData = awgn(data,snr);% Add noise
    % Add frequency offset to baseband signal
    freqShift = exp(1i.*2*pi*frequencyOffsetHz./sampleRateHz*(1:numSamples)).';
    offsetData = noisyData.*freqShift;
    %% Calculate coefficients for FFC
    PhaseRecoveryLoopBandwidth = NormalizedLoopBandwidth*samplesPerSymbol;
    PhaseRecoveryGain = samplesPerSymbol;
    PhaseErrorDetectorGain = order/2; % QPSK=2 BPSK=1
    DigitalSynthesizerGain = -1;
    theta = PhaseRecoveryLoopBandwidth/((DampingFactor + 0.25/DampingFactor)*samplesPerSymbol);
    d = 1 + 2*DampingFactor*theta + theta*theta;
    % K1
    ProportionalGain = (4*DampingFactor*theta/d)/(PhaseErrorDetectorGain*PhaseRecoveryGain);
    % K2
    IntegratorGain = (4/samplesPerSymbol*theta*theta/d)/(PhaseErrorDetectorGain*PhaseRecoveryGain);
    %% Correct carrier offset
    output = zeros(size(offsetData));
    Phase = 0; previousSample = complex(0);
    LoopFilter.release();Integrator.release();
    for k = 1:length(offsetData)-1
        % Complex phase shift
        output(k) = offsetData(k+1)*exp(1i*Phase);
        % PED
        phErr = sign(real(previousSample)).*imag(previousSample) - sign(imag(previousSample)).*real(previousSample);
        phErrs(k,index) = phErr;
        %phErr = sign(real(previousSample))*imag(previousSample);
        % Loop Filter
        loopFiltOut = step(LoopFilter,phErr*IntegratorGain);
        % Direct Digital Synthesizer
        DDSOut = step(Integrator,phErr*ProportionalGain + loopFiltOut);
        Phase =  DigitalSynthesizerGain * DDSOut;
        PhaseAcc(k,index) = Phase;
        previousSample = output(k);
    end
    %evm = comm.EVM;
    %rmsEVM = evm(data, output)
    %scatterplot(output(end-1024:end-10));title('');grid on;
    index = index + 1;
end
%%
%f1 = figure(1);
freqEst = -sampleRateHz*diff(PhaseAcc(1:end-3,1))/(2*pi);
plot(freqEst,'r');
ylim([0,25000])
grid on