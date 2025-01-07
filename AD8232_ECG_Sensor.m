% Define parameters
port = "COM6";          % Replace with your ESP32's COM port
baudRate = 230400;      % Match the baud rate in your ESP32 code
bufferSize = 500;       % Number of data points to display in the plot
fs = 250;               % Sampling frequency
lowPassCutoff = 100;    % Low-pass cutoff frequency in Hz
highPassCutoff = 0.5;   % High-pass cutoff frequency in Hz

% Ensure cutoff frequencies are within the valid range
if lowPassCutoff >= fs / 2
    error('Low-pass cutoff frequency must be less than fs/2');
end

% Create serialport object
device = serialport(port, baudRate);

% Allocate storage for data buffers
timeBuffer = zeros(bufferSize, 1); % Time buffer
ecgBuffer = zeros(bufferSize, 1);  % Filtered ECG buffer
rawBuffer = zeros(bufferSize, 1);  % Raw ECG buffer
timeStamp = 0;                     % Initialize time counter
timeStep = 1 / fs;                 % Time step based on sampling frequency

% Design bandpass Butterworth filter
[b, a] = butter(4, [highPassCutoff, lowPassCutoff] / (fs / 2)); % 4th-order filter

% Initialize the plot
figure;
plotHandle = plot(NaN, NaN, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude (Filtered)');
title('Real-Time Filtered ECG Signal');
grid on;

disp('Press Ctrl+C to stop.');

% Buffer to store past filter states for continuity
zi = zeros(max(length(a), length(b)) - 1, 1);

try
    while true
        % Read data from the serial port
        dataLine = readline(device);
        
        % Parse the incoming data
        value = str2double(dataLine); % Convert string to numerical value
        if ~isnan(value)
            % Display raw value in Command Window
            disp(['Raw Value: ', num2str(value)]);
            
            % Store raw value into the buffer
            rawBuffer = [rawBuffer(2:end); value];
            
            % Filter the raw data (continuity with filter states)
            [filteredValue, zi] = filter(b, a, value, zi); % Update filter state
            
            % Update buffers
            timeStamp = timeStamp + timeStep;
            timeBuffer = [timeBuffer(2:end); timeStamp];      % Shift and append new time
            ecgBuffer = [ecgBuffer(2:end); filteredValue];    % Shift and append filtered value
            
            % Update the plot
            set(plotHandle, 'XData', timeBuffer, 'YData', ecgBuffer);
            ylim([min(ecgBuffer) - 0.1, max(ecgBuffer) + 0.1]); % Adjust y-limits dynamically
            drawnow;
        else
            warning('Received non-numeric data, skipping...');
        end
    end
catch ME
    % Error handling and cleanup
    disp('Terminating...');
    disp(ME.message);
    clear device;  % Clean up the serial port
end
