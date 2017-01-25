% Lab 2 - Ex 2 - Capture and analyse microphone sound signal

clear all 
close all

pb = PyBench('/dev/tty.usbmodem1412');

if pb.ok()
    display('PyBench is working')
else
    display('PyBench is NOT working')
end

% Set parameters
fs = 8000;
pb = pb.set_samp_freq(fs);

% Capture N samples
N = 1000;
samples = pb.get_mic(N);
data = samples - mean(samples); % centre the data on the x axis

% Plot data
figure
clf
plot(data);
xlabel('Sample no');
ylabel('Signal voltage (V)');
title('Microphone signal');

% Find spectrum
figure(2)
plot_spectrum(data, fs);

% Initiate a while loop that continuously reads data

n = 0;
while n < 100 % prevents an endless loop
    n = n + 1;
    
    % Capture N samples
    samples = pb.get_mic(N);
    data = samples - mean(samples); % centre the data on the x axis

    % Plot data
    
%     figure(1)
%     plot(data);
%     xlabel('Sample no');
%     ylabel('Signal voltage (V)');
%     title('Microphone signal');

    % Find spectrum
    figure(2)
    plot_spectrum(data, fs);
end