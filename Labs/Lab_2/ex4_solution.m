%% ex4 solution

clear all
close all

[sig fs] = audioread('sounds/two_drums.wav');
% sound(sig, fs);
figure; set(gcf,'color','w');
plot(sig);
xlabel('Sample no');
ylabel('Signal (V)');
title('Two drums');

% Divide signal into segments and find energy
T = 0.02;
N = fs*T;
E = [];

for i = 1:N:length(sig)-N+1
    seg = sig(i:i+N-1);
    E = [E seg'*seg];
end

% plot the energy graph and the peak values

figure; set(gcf,'color','w');
x = 1:length(E);
plot(x,E);
xlabel('Segment number');
ylabel('Energy');
hold on
[pks, locs] = findpeaks(E);
plot(locs, pks, 'o');
hold off

figure; set(gcf,'color','w');
plot_spec_dB(E,1/T);
