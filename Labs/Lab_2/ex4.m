%% Lab 2 - Exercise 4
% This is an attempt at exercise 4 but does not produce the correct
% results. For correct results and code, see the 'ex4_solution.m' file.

clear all
close all

[sig fs] = audioread('sounds/two_drums.wav');
% sound(sig, fs);
figure; set(gcf,'color','w');
plot(sig);
xlabel('Sample no');
ylabel('Signal (V)');
title('Two drums');

%% Get first 20 msec segment
% fs = 44100;

N = length(sig);
T = N/fs;
dt = 1/fs;

t_seg = 20E-3;
n = round(t_seg/dt); % number of samples in segment

segment1 = sig(1:n); % save first segment
segment2 = sig(n+1:2*n);

%% Calculate energy in segment

seg1_energy = sum(segment1.^2)
seg2_energy = sum(segment2.^2)

%% Plot energy against sample and locate peaks

sample_nos = 1:length(segment1);
segment1energy = segment1.^2;
segment2energy = segment2.^2;

[pks,locs] = findpeaks(segment1energy); % finds peaks in spectrum
figure
plot(segment1energy); hold on;
plot(sample_nos(locs),pks,'or'); hold off;
xlabel('Sample no');
ylabel('Energy');
title('First drum energy');
set(gcf,'color','w');

[pks,locs] = findpeaks(segment2energy);
figure
plot(segment2energy); hold on;
plot(sample_nos(locs),pks,'or'); hold off;
xlabel('Sample no');
ylabel('Energy');
title('Second drum energy');
set(gcf,'color','w');

%% Find dominant frequencies of each drum

figure;
set(gcf,'color','w');

subplot(2,1,1)
plot_spec_dB(segment1, fs);
title('Drum 1 frequency domain');

subplot(2,1,2)
plot_spec_dB(segment2, fs);
title('Drum 2 frequency domain');
set(gcf,'color','w');