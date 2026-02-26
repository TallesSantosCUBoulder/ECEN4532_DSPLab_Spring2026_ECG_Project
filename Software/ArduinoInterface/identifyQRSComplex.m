% For the best and most accurate data, the inputted signal need to be 
% filtered first
function [R_loc, left, right, bpm]=identifyQRSComplex(signal,Fs)
%% Preprocessing the signal for QRS detection
x = signal;

% Removing the DC Offset from the Signal
x = x - mean(x);

% Finding the Time Scale of the Signal
T = 1/Fs;
N = length(x);

t = (0:N-1)*T;

% Normalizing the Signal
Norm_signal = x.^2;
Norm_signal = Norm_signal / max(abs(Norm_signal));


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

% The R_loc variable is the location of the R values that make up a QRS
% Complex
for i=1:length(left)
    [R_value(i) R_loc(i)] = max(x(left(i):right(i)));
    R_loc(i) = R_loc(i)-1+left(i); % add offset
end

freq_heartbeat = length(left)/max(t);

% Convert frequency to beats per minute
bpm = freq_heartbeat * 60;


end