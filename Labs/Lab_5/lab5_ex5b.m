%% Lab 5
%
% Exercise 5a
% 4-taps Moving average filter
% Using the inefficient method

clear all
[sig, fs] = audioread('bgs.wav');

% Add noise to music
x = sig + 0.2*rand(size(sig));

% Plot the signal
figure(1);
clf;
plot(x);
xlabel('Sample no.');
ylabel('Signal (V)')
title('Staying Alive Music');

% Filter music with moving average filter
N = size(x);
N_tap = 20

for i=N_tap:N
    temp = 0;
    for j = 0:N_tap-1
        temp = temp + x(i-j);
    end
    y(i) = temp / N_tap;
end

% Play the original & then filtered sound
sound(x,fs)
disp('Playing the original - press return when finished')
pause;
sound(y,fs)
disp('Playing filtered music')
