%{ 
Midterm Problem 3
Linear Systems
Alyssa Jackson
%}

close all; clear all; clc;

%% load signal
ECG_signal = load('./100m.mat') ;
x = ECG_signal.val ;
Fs = ECG_signal.Fs ;

% Removing the DC Offset from the Signal
x = x - mean(x);

% Finding the Time Scale of the Signal
T = 1/Fs;
N = length(x);

t = (0:N-1)*T;

% Normalizing the Signal
Norm_signal = x.^2;
Norm_signal = Norm_signal / max(abs(Norm_signal));

figure("Name","Part 1");
plot(t, Norm_signal)
title('ECG signal example')
xlabel("Time (sec)");
ylabel("Amplitude (V)");

% FTT Computations
Y = abs(fft(x));

f = ([0:N-1]/N)*Fs;

figure("Name","Part 2")
subplot(2,1,1)
plot(f, Y)
title("FFT ECG Signal")
xlabel("Frequency (Hz)");
ylabel("Amplitude (|X(f)|)");

subplot(2,1,2)
plot(f, Y)
xlabel("Frequency (Hz)");
ylabel("Amplitude (|X(f)|)");
xlim([30 65])

% Filtering Out the Noise from the Signal
% Noise Frequencies
fc1 = 35;
fc2 = 60;
fc = [5 30];

fs = Fs;
syms z;
[b,a] = butter(6,fc/(fs/2));
%freqz(b,a,[],fs);
filtered_data= filtfilt(b, a, x); % zero-phase shift

figure("Name","Part 3 (i")
plot(t, filtered_data)
title("Filtered ECG Signal w/ filtfilt function")
xlabel("Time (sec)");
ylabel("Amplitude (V)");

Y2 = abs(fft(filtered_data));

f = ([0:N-1]/N)*Fs;

figure("Name","Part 3 (ii")
subplot(2,1,1)
plot(f, Y2)
title("FFT ECG Signal")
xlabel("Frequency (Hz)");
ylabel("Amplitude (|X(f)|)");

subplot(2,1,2)
plot(f, Y2)
xlabel("Frequency (Hz)");
ylabel("Amplitude (|X(f)|)");
xlim([30 65])

% Finding the QRS Complex Peaks
h = ones (1,36)/36; % 0.1secs
% Apply filter
x = conv (Norm_signal ,h,'same');
x = x/max(abs(x));

max_h = max(x);
thresh = 2*mean(x);
poss_reg =(x>thresh*max_h)';

left = find(diff([0 poss_reg'])==1);
right = find(diff([poss_reg' 0])==-1);

for i=1:length(left)
    [R_value(i) R_loc(i)] = max(x(left(i):right(i)));
    R_loc(i) = R_loc(i)-1+left(i); % add offset
end

freq_heartbeat = length(left)/max(t);

% Using Findpeaks functions
[pks, locs] = findpeaks(Norm_signal);
other_freq = length(pks)/max(t);

figure("Name","Part 5")
subplot(2,1,1); hold on;
plot(t,x,'b')
plot(t(R_loc),x(R_loc),'m*','LineWidth',5)
title(['Dominant Frequency of the ECG is ', num2str(freq_heartbeat), 'Hz'])
xlabel("Time (sec)");
ylabel("Amplitude (V)");

subplot(2,1,2); hold on;
plot(t,x,'b')
plot(t(locs),x(locs),'m*','LineWidth',5)
title(['Dominant Frequency of the ECG is ', num2str(other_freq), 'Hz'])
xlabel("Time (sec)");
ylabel("Amplitude (V)");

% Safe to say that our code calculation is much more accurate than the
% findpeaks() function due to the fact that we can find the QRS Complex
% and use it to find the highest peak to find the bpm.