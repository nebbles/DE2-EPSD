%% Lab 3 Exercise 3a
% 

clear all
close all

pb = PyBench('/dev/tty.usbmodem1412');

if pb.ok()
    display('PyBench is working')
else
    display('PyBench is NOT working')
end

%% Measuring G(j?) for a range of frequencies
% We set our range of frequencies from 1 to 20 and we measure 50 times
% within this range (for a high resolution graph).

set_f = linspace(1,20,50);
Gvals = zeros(1,length(set_f));

for i=1:length(set_f)
     Gvals(i) = system_gain(pb,set_f(i));
end

figure; set(gcf,'color','w');
plot(set_f,Gvals);
title('Frequency Response - Experimental');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');

%% End experiment
pb.dc(0); % turn off bulb at the end of exercise

%% Function for system gain

function G = system_gain(pb,set_f)
    % Generate a sine wave at sig_freq Hz
    max_x = 2.1;
    min_x = 1.9;
    f_sig = set_f;
    pb = pb.set_sig_freq(f_sig);
    pb = pb.set_max_v(max_x);
    pb = pb.set_min_v(min_x);
    pb.sine();
    pause(2);

    % Capture output y(t)
    pb = pb.set_samp_freq(100);
    N = 300;
    y = pb.get_block(N);

    % Compute gain in dB
    x_pk2pk = max_x - min_x;
    y_pk2pk = max(y) - min(y);
    G = 20 * log10(y_pk2pk/x_pk2pk)
end