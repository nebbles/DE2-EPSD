%% Lab3 ex3
% Measure system gain at frequency f_sig

clear all
close all

pb = PyBench('/dev/tty.usbmodem1412');

if pb.ok()
    display('PyBench is working')
else
    display('PyBench is NOT working')
end


%% Measure system gain at frequency f_sig
% For a set of frequencies, [0, 1, 5, 10] we find the system gain.

y1 = system_gain(pb,0);
y2 = system_gain(pb,1);
y3 = system_gain(pb,5);
y4 = system_gain(pb,10);

% Plot signal
figure; set(gcf,'color','w');
plot(y1)
title('Lab 3 Exercise 3 - Bulb box output')
xlabel('Sample no.')
ylabel('Output voltage (V)')
hold on
plot(y2)
plot(y3)
plot(y4)
legend('0 Hz','1 Hz','5 Hz','10 Hz');


%%
pb.dc(0); % turn off bulb at the end of exercise


%% Function for the system gain

function y = system_gain(pb,set_f)
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