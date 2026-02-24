%{ 
Midterm Problem 2
Linear Systems
Alyssa Jackson
%}

close all; clear all; clc;

%% load signal
ECG_signal = load('ECG_Signal_Q2b.mat') ;
x = ECG_signal.ECG_signal ;
Fs = ECG_signal.Fs ;

%% settings
x = x-mean(x);             % remove DC
x = x/max(abs(x));         % Normalize

T = 1/Fs;                  % Sampling period       
N = length(x);             % Length of signal
n = (0:N-1);               % sample vector
t = (0:N-1)*T;             % Time vector

figure(); hold on;
plot(t,x)
title('ECG signal example')


%% FFT (360 Hz)
Y = fft(x)/length(x);
f = n/N * Fs;

figure()
hold on;
plot(f,abs(Y)) 
title("Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|X(w)|")



%% Linear Interpolation 
% Resample the signal x, originally sampled at 360 Hz, by applying linear
% interpolation to obtain a new signal sampled at 1080 Hz.
% x -> linear interpolation -> x_interpolate

% set number of points in the interpolation
number_point_interpolation = 1080 ;
% expand vector x (zero pad)
x_zero = zeros(1,length(x)*number_point_interpolation) ;
x_zero(1:number_point_interpolation:end) = x ;
% adjust x axis
nx = n*number_point_interpolation ;
nx_int = [0:length(x_zero)-1];

h0_1 = 1*[-number_point_interpolation:0] + number_point_interpolation ;
h0_2 = -1*[1:number_point_interpolation] + number_point_interpolation ;
h0 = [h0_1 h0_2]/number_point_interpolation ;

figure()
plot([-number_point_interpolation:number_point_interpolation],h0,'.-')
title('interpolator')
% Convolution
x_interpolate = conv(x_zero,h0,'same') ;



%% FFT (1080 Hz)
Y = fft(x_interpolate)/length(x_interpolate);

N_interpolate = length(x_interpolate);
FS_interpolate = 1080 ;
f = [0:N_interpolate-1]/N_interpolate * FS_interpolate;

figure()
hold on;
plot(f,abs(Y)) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|X(w)|")



