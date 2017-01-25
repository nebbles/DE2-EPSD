function plot_fullspectrum( sig, fs )
% Function to plot frequency spectrum of sig
%   usage:
%           plot_spectrum(sig, 8192)

    magnitude = abs(fft(sig));
    N = length(sig);
    df = fs / N;
    f = -fs/2:df:fs/2-df;
    
    % create empty Y array
    Y = zeros(length(f));
    % set the first half of the Y array
    Y(1:length(f)/2) = magnitude(length(f)/2+1:length(f));
    % set the second half of the Y array
    Y(length(f)/2+1:length(f)) = magnitude(1:length(f)/2);
    
    figure
    plot(f, Y/(N)*2);
    xlabel('\fontsize{14}frequency (Hz)');
    ylabel('\fontsize{14}Magnitude');
end