% Lab 2 - Ex 1 - Signal generation

clear all
close all

pb = PyBench('/dev/tty.usbmodem1412');

if pb.ok()
    display('PyBench is working')
else
    display('PyBench is NOT working')
end

% Set the various parameters
f = 440;
fs = 8000;
pb = pb.set_sig_freq(f);
pb = pb.set_samp_freq(fs);
pb = pb.set_max_v(3.0);
pb = pb.set_min_v(0.5);
pb = pb.set_duty_cycle(50);

% Generate a signal
pb.sine();
capture_plot(pb, fs)

% Generate a signal
pb.triangle(); 
capture_plot(pb, fs)

% Generate a signal
pb.square(); 
capture_plot(pb, fs)

function capture_plot(pb, fs)

% Capture N samples
N = 1000;
samples = pb.get_block(N);
data = samples - mean(samples); % centre the data on the x axis
% Plot data
figure;
plot(data(1:200),'o'); hold on
plot(data(1:200)); hold off
xlabel('Sample no');
ylabel('Signal voltage');
title('Captured signal');

plot_fullspectrum(data, fs);

end