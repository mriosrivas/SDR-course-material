sequence1 = Zadoff_Chu(32, 5, 31);
sequence2 = Zadoff_Chu(64, 5, 63);
corr1 = xcorr(sequence1);
corr2 = xcorr(sequence2);


figure(1)
scatter(real(sequence1), imag(sequence1))
title('Zadoff-Chu sequence with L=32, k=31 and q=5')
grid 'on'

figure(2)
scatter(real(sequence2), imag(sequence2))
title('Zadoff-Chu sequence with L=64, k=63 and q=5')
grid 'on'

figure(3)
stem(abs(corr1))
title('Zadoff-Chu auto-correlation with L=32, k=31 and q=5')
grid 'on'

figure(4)
stem(abs(corr2))
title('Zadoff-Chu auto-correlation with L=64, k=63 and q=5')
grid 'on'