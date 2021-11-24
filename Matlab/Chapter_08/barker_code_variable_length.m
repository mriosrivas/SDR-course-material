% Code example showing different Barker codes sequences of length N.
sequenceLength = [7, 11, 13];

i = 0;

for sequenceLengthValue = sequenceLength
    
    %sequenceLengthValue; %Change to a fixed value, i.e. 13 to see effect.
    SamplesPerFrame = 13; 
    
    hBCode = comm.BarkerCode('Length',sequenceLengthValue,'SamplesPerFrame', SamplesPerFrame); 
    seq = hBCode();
    corr = xcorr(seq,seq); 
    
    subplot(3,2,i+1);
    stem(seq)
    ylim([-2 2])
    xlim([0 14])
    title(['Barker Code N = ' num2str(sequenceLengthValue)])
    
    subplot(3,2,i+2);
    stem(corr)
    i = i+2;
    ylim([-1 15])
    xlim([0 26])
    title(['Autocorrelation Barker Code N = ', num2str(sequenceLengthValue),...
        ',    Samples per Frame M = ', num2str(SamplesPerFrame)])
    
end