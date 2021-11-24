%% Specify plot parameters
txtsize=10;
ltxtsize=9;
pwidth=4;
pheight=4;
pxoffset=0.65;
pyoffset=0.5;
markersize=5;
%% Example 1:
% Spurious-free dynamic range, SFDR, of a quantized sinusoidal signal with
% fundamental frequency 3,959,297Hz (This is a prime number) and floating
% point precision.
deltat = 1e-8;
fs = 1/deltat;
t = 0:deltat:1e-5-deltat;
fundamental=3959297;
x = 10e-3*sin(2*pi*fundamental*t);
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);

%% Example 2:
% Same signal as Example 1, with 12 bits resolution and scale factor
% between -10e-3 and 10e-3.
bits=2^11;
x = round(10e-3*bits*sin(2*pi*fundamental*t))/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);

%% Example 3:
% Same signal as Example 1, with 12 bits resolution and normalized signal
% to enhace SDFR.
bits=2^11;
x = round(bits*sin(2*pi*fundamental*t))/bits;
r = sfdr(x,fs) 
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);

%% Example 4:
% Same signal as Example 1, with 12 bits resolution and but number of
% samples was increased to increment the number of FFT bins, which in turn
% decreases the energy accumulated in each bin.
t = 0:deltat:1e-4-deltat;
x = round(bits*sin(2*pi*fundamental*t))/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);

%% Example 5:
% Quantized sinusoidal signal with fundamental frequency 4MHz
fundamental=4000000;
x = round(bits*sin(2*pi*fundamental*t))/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);

%% Example 6:
% Same signal as Example 5, but we can use a technique known as dithering.
% This moves the energy accumulated in the harmonics and pushes it out into 
% the rest of the noise floor.
ran = rand(1,length(t)) - 0.5;
x = round(bits*sin(2*pi*fundamental*t) + ran)/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);

%% Example 7:
% Example of use of dithering in the signal with fundamental frequency of
% Example 1.
fundamental=3959297;
x = round(bits*sin(2*pi*fundamental*t) + ran)/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);
