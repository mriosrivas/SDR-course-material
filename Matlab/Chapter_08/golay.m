N = 32;
[Ga,Gb] = wlanGolaySequence(N);

figure(1)
subplot(2,1,1)
stem(Ga);
title('Golay Ga32')
axis([0, N+1, -2, 2])
grid 'on'

subplot(2,1,2)
stem(Gb)
title('Golay Gb32')
axis([0, N+1, -2, 2])
grid 'on'

figure(2)
stem(xcorr(Ga)+xcorr(Gb))
title('Autocorrelation of Ga32 + Gb32');
grid 'on'