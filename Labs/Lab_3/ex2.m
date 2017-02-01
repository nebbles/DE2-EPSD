%% Lab 3 ex2
% Program to plot theoretical freq. response to bulb

clear all
close all

f = 0:0.1:20; % This range is selected because it is known that system?s 
% oscillatory behaviour is well below 20Hz.

D = [0.038, 1.19, 43, 1000]; % Creates a vector specifying the coefficients
% of the denominator polynomial of G(s), in the order of highest power of 
% s to lowest power.

s = i*2*pi*f; % s is the vector specifying the frequency of interest. Note 
% that to get the frequency response, we evaluate G(s) at s = j?, where 
% ? = 2?f. Matlab uses i to specify imaginary number instead of j.

G = 1000./ abs(polyval(D,s)); % This calculates G at the different 
% frequencies. Look up Matlab help page for polyval(.) function.

Gdb = 20*log10(G); % Conversion of gain into decibels.

figure; set(gcf,'color','w');
plot(f,Gdb);
title('Frequency Response - Theoretical');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
