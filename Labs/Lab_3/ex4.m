%% Lab3 ex4
% Measure system gain at frequency f_sig

clear all
close all

pb = PyBench('/dev/tty.usbmodem1412');

if pb.ok()
    display('PyBench is working')
else
    display('PyBench is NOT working')
end

%% Setting parameters

fs = 100; % sampling frequency
pb = pb.set_samp_freq(fs);
pb = pb.set_sig_freq(0.1);
pb = pb.set_max_v(2.5);
pb = pb.set_min_v(1.5);
pb = pb.set_duty_cycle(50);

% Generate square signal
pb.square()
N = 1000;

figure; set(gcf,'color','w');
iterator = 0;
while iterator < 5
    iterator = iterator + 1
    data = pb.get_block(N)
    clf
    plot(data)
    xlabel('Sample no')
    ylabel('Output (V)')
    title('Step Response - Experimental')
end

%% End experiment

pb.dc(0); % turn off bulb at the end of exercise

