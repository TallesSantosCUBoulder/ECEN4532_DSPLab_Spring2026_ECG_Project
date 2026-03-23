%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ECEN4532 - DSP Lab (Module 02)
% Osciloscope Mode - Talles Santos 2/19/26
% Rotine that read serial port data and plot in real time

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all ; clear all ; clc

% define port; check whatever port the Arduino is connected to
% and uncomment that one while commenting the other ports
portName = serialportlist("available");
portName = '/dev/ttyACM0' ;
% portName = '/dev/ttyACM1' ;
% portName = '/dev/ttyUSB0' ;

% open port
fp = serialport(portName,115200);

% settings
fs = 1 / (3e-3) ;                % sampling frequency of the arduino
sizeBufferArduino = 20 ;         % from arduino code
t_Buffer = 10.0 ;                   % in seconds
nSamplesBuffer = round(t_Buffer*fs) ;   % nSamples of the circular buffer in the matlab script
bits2volts = 5/(2^10-1) ;            % convertion from bits to volts (arduino uno 10 bits)

% initialing variables
CircularBuffer = zeros(nSamplesBuffer,1);
vecSamples = 0 ;
count=1;


%% 
figure
while(true)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAFE SERIAL READ (FIXED)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % vec_samples_aux = zeros(sizeBufferArduino,1);

    for i = 1:sizeBufferArduino
        line = readline(fp);           % guarantees full line ending in \n
        val = str2double(line);        % safer than str2num

        if isnan(val)
            continue; % skip bad data instead of crashing
        end

        vec_samples_aux(i) = val;
    end
    
    % validation guard (prevents crash)
    if isempty(vec_samples_aux) || all(vec_samples_aux == 0)
        continue;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % circular buffer and convert to volts
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nValid = min(length(vec_samples_aux), sizeBufferArduino);

    for i = 1:nValid
        CircularBuffer(count) = vec_samples_aux(i) * bits2volts;
        count = mod(count, nSamplesBuffer) + 1;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % your function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [R_loc, left, right, bpm] = identifyQRSComplex(CircularBuffer, fs);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot osciloscope
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t = linspace(0,1/fs*nSamplesBuffer,nSamplesBuffer);

    plot(t,CircularBuffer,'b')
    hold on;

    % vertical cursor
    count_aux = mod(count-2,nSamplesBuffer)+1;
    plot(t(count_aux),CircularBuffer(count_aux),'r.')
    plot([t(count_aux) t(count_aux)],[-0.2 5.5],'r');

    % QRS markers
    plot(t(R_loc),CircularBuffer(R_loc),'m*','LineWidth',5)
    plot(t(left), CircularBuffer(left), 'r*')
    plot(t(right), CircularBuffer(right), 'g*')

    % formatting
    xlim([0 t_Buffer]);
    ylim([-0.2 5.5])
    xlabel('t(secs)');
    ylabel('V(volts)')
    hold off;

    title(['osciloscope; BPM: ', num2str(bpm)]);

    drawnow

end

fclose(fp);


