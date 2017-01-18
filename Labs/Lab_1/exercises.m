%% Exercise 1: Testing sine_gen

s1 = sine_gen(1.0, 440, 8192, 1);

figure
plot(s1(1:200));
xlabel('\fontsize{14}Sample number');
ylabel('\fontsize{14}Amplitude');
title('\fontsize{16}440Hz sinewave');

%% Exercise 2: Testing plot_spectrum

s1 = sine_gen(1.0, 440, 8192, 1);

figure
plot_spectrum(s1, 8192);
title('Spectrum');

%% Exercise 3: Two tones

s1 = sine_gen(1.0, 440, 8192, 1);
s2 = sine_gen(0.5, 1000, 8192, 1);
sig = s1 + s2;

figure
plot(s1(1:200)); hold on;
plot(s2(1:200)); hold off;
title('Exercise 3: Two tones (before adding)');

figure
plot(sig(1:200));
title('Exercise 3: Two tones (after adding)');
figure
plot_spectrum(sig, 8192);

%% Exercise 4: Two tones + noise

noisy = sig + randn(size(sig));

figure
plot(noisy(1:200));
title('Exercise 4: Two tones + noise');
figure
plot_spectrum(noisy, 8192);

%% Exercise 5: Projection using dot product

dp_s1_on_s2 = s1 * s2'

s3 = sine_gen(1.0, 441, 8192, 1);
dp_s1_on_s3 = s1 * s3'

dp_s1s2_on_s1 = (s1+s2) * s1'


