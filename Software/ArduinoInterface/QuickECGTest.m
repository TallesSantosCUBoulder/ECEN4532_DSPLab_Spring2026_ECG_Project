%% Another quick ECG Test

close all; clear all;

%% load signal
ECG_signal = load('100m.mat') ;
x = ECG_signal.val ;
Fs = ECG_signal.Fs ;

T = 1/Fs;
N = length(x);

t = (0:N-1)*T;

% Calling the Function
[R_loc, left, right, bpm] = identifyQRSComplex(x, Fs);

% Normalizing the Signal
Norm_signal = x.^2;
Norm_signal = Norm_signal / max(abs(Norm_signal));


freq_heartbeat = length(left)/max(t);


figure("Name","Part 5"); hold on;
plot(t,x,'b')
plot(t(R_loc),x(R_loc),'m*','LineWidth',5)
plot(t(left), x(left), 'r*')
plot(t(right), x(right), 'g*')
title(['Dominant Frequency of the ECG is ', num2str(freq_heartbeat), 'Hz'])
xlabel("Time (sec)");
ylabel("Amplitude (V)");
