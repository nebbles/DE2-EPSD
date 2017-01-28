function plot_spectrum_peaks( sig, fs )
% Function to plot frequency spectrum of sig
%   usage:
%           plot_spectrum(sig, 8192)

    magnitude = abs(fft(sig));
    N = length(sig);
    df = fs / N;
    f = 0:df:fs/2;
    Y = magnitude(1:length(f));
    
    [pks,locs] = findpeaks(Y/(N)*2); % finds peaks in spectrum
    
    figure % ensures plot is placed on new figure
    plot(f, Y/(N)*2,f(locs),pks,'or'); % plots spectrum and circles peaks
    xlabel('\fontsize{14}frequency (Hz)');
    ylabel('\fontsize{14}Magnitude');
    
    frequency_magnitude_peaks = transpose([f(locs);pks]) 
    % peaks are stored in an array where 
    % column 1 is frequency
    % column 2 is magnitude at respective frequencies

end