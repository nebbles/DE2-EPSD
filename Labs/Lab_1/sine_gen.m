function [sig] = sine_gen(amp, f, fs, T) % Function to generate a sine wave
%     
%     fs = sampling frequency
%     T = duration
%     usage:  signal = sine_gen(1.0, 440, 8192, 1)

    dt = 1 / fs;
    t = 0:dt:T;
    sig = amp*sin(2*pi*f*t);
end