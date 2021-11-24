clear all;
max = 20;
fs = 1000;

scope = dsp.SpectrumAnalyzer;
scope.SpectrumType = 'Power';
scope.SampleRate = fs;
scope.SpectralAverages = 1;
scope.PlotAsTwoSidedSpectrum = false;
scope.RBWSource = 'Auto';

for i = 1:2:max
    % dsp.SineWave(amp,freq,phase,Name,Value);
    % pi - 2*sum(sin(n*x)/n))
    wave = dsp.SineWave(2/i, i*2*pi, 0, ...
        'SamplesPerFrame', 5000, 'SampleRate', fs);

    y = wave();
    if i == 1
        wavesum = y;
    else
        wavesum = wavesum + y;
    end
   
    figure(1);
    plot(wavesum(1:500));
    title(sprintf('Sum to %i', i));
    ylabel('Amplitude');
    xlabel('Time');

    scope(wavesum());
    pause(.5);
    % waitforbuttonpress; 
end
