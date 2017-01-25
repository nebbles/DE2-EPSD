function plot_spectrum( sig, fs )
% Function to plot frequency spectrum of sig
%   usage:
%           plot_spectrum(sig, 8192)

    magnitude = abs(fft(sig));
    N = length(sig);
    df = fs / N;
    f = 0:df:fs/2;
    Y = magnitude(1:length(f));
    figure
    plot(f, Y/(N)*2);
    xlabel('\fontsize{14}frequency (Hz)');
    ylabel('\fontsize{14}Magnitude');

end

