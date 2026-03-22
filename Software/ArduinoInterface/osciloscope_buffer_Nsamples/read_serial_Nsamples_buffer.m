%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ECEN4532 - DSP Lab (Module 02)
% Osciloscope Mode - Talles Santos 2/19/26
% Rotine that read serial port data and plot in real time

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all ; clear all ; clc

% define port; check whatever port the Arduino is connected to
% and uncomment that one while commenting the other ports
portName = serialportlist("available");
% portName = '/dev/ttyACM0' ;
% portName = '/dev/ttyACM1' ;
portName = '/dev/ttyUSB0' ;

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

    % find the first '\n' to know where to start to read
    while(vecSamples~=10)
        vecSamples = read( fp , 1 , "uint8" ) ;
    end

    % read serial port
    vecSamples = read( fp , 5*sizeBufferArduino , "uint8" ); % try to read 5, because each number is "XXXX\n"

    % take the serial port data and convert to a vector
    vec_samples_aux = str2num(char(vecSamples));
    vecSamples = vecSamples(end); % if it is \n, it keeps reading, if not will go to the first while of this loop


    % cirular buffer and convert to volts
    for i=1:sizeBufferArduino
        CircularBuffer(count) = vec_samples_aux(i)*bits2volts ;
        count=mod(count,nSamplesBuffer)+1;
        % idx = mod(count-1, numel(CircularBuffer)) + 1;
        % CircularBuffer(idx) = vec_samples_aux(i)*bits2volts;

    end

    % toc

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % your function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calling the Function
    [R_loc, left, right, bpm] = identifyQRSComplex(CircularBuffer, fs);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot osciloscope
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    t = linspace(0,1/fs*nSamplesBuffer,nSamplesBuffer);
    freq_axis = linspace(0,fs,nSamplesBuffer);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % first plot (time domain)

    % plot circular buffer in the time domain
    plot(t,CircularBuffer,'b')

    hold on ;

    % plot vertical line
    count_aux = mod(count-2,nSamplesBuffer)+1;
    plot(t(count_aux),CircularBuffer(count_aux),'r.')
    plot([t(count_aux) t(count_aux)],[-0.2 5.5],'r');

    % Plotting the left, right, and QRS peak of the signal
    plot(t(R_loc),CircularBuffer(R_loc),'m*','LineWidth',5)
    plot(t(left), CircularBuffer(left), 'r*')
    plot(t(right), CircularBuffer(right), 'g*')

    % Handling the Size and specifics of the real time plotting
    xlim([0 t_Buffer]);
    ylim([-0.2 5.5])
    xlabel('t(secs)');
    ylabel('V(volts)')
    hold off;
    title('osciloscope; BPM: ', num2str(bpm));

    drawnow

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end


fclose(fp);




