%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Osciloscope Mode - Talles Santos 4/17/23
% Rotine that read serial port data and plot time series and fft
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all ; clear all ; clc

% define port
portName = serialportlist("available");
portName = '/dev/ttyACM0' ;

% open port
fp = fopen( portName , 'r' );


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
    while(vecSamples~=10) % \n is 10 in ascii
        if(feof(fp)==0)
            vecSamples = fread( fp , 1 , "uint8" ) ;
        else
            fseek(fp,0,'cof'); % if find 'eof', keep reading
        end
    end

    % tic
    if(feof(fp)==0)  % if it is not the end of the file
        [vecSamples,nbytes] = fread( fp , 5*sizeBufferArduino , "uint8" ); % try to read 5, because each number is "XXXX\n"
    else
        fseek(fp,0,'cof'); % if find 'eof', keep reading
    end

    % when the is no data available, continue up to have it ready
    if( nbytes<5*sizeBufferArduino)
        fseek(fp,-nbytes,"cof");
        disp('no available data')
        continue;
    end

    % take the serial port data and convert to a vector
    vec_samples_aux = str2num(char(vecSamples'));
    vecSamples = vecSamples(end); % if it is \n, it keeps reading, if not will go to the first while of this loop


    % cirular buffer and convert to volts
    for i=1:sizeBufferArduino
        CircularBuffer(count) = vec_samples_aux(i)*bits2volts ;
        count=mod(count,nSamplesBuffer)+1;
    end

    % toc

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % your function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % plot osciloscope

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

    xlim([0 t_Buffer]);
    ylim([-0.2 5.5])
    xlabel('t(secs)');
    ylabel('V(volts)')
    hold off;
    title('osciloscope');

    

    drawnow
    pause(0.04)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end


fclose(fp);




