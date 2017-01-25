function [Y] = plot_spec_dB(sig, fs)

% Function to plot frequency spectrum of sig in dB
%   usage: 
%           plot_spectrum_dB(sig, fs)
%
% author: Peter YK Cheung, 17 Jan 2017
    magnitude = abs(fft(sig));
    N = length(sig);
    df = fs/N; 
    f = 0:df:fs/2;
    m_max = max(magnitude);
    Y = 20*log10(magnitude(1:length(f))/m_max);
    plot(f, Y)
       axis([0 fs/2 -60 0]);
    xlabel('\fontsize{14}frequency (Hz)')
    ylabel('\fontsize{14}Magnitude (dB)');
    title('\fontsize{16}Spectrum');
  