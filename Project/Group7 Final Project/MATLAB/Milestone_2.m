clear all
[sig fs] = audioread('BeeGees.wav'); % short file segment

sound(sig, fs)
figure(1)
plot(sig);
xlabel('Sample no');
ylabel('Signal (v)');
title('bgs');

% Divide signal into segments to find its energy
T = 0.02;   % divide signal into 20ms segments
N = fs*T;   % for this duration, we need N samples
E = [];
for i = 1:N:length(sig)-N+1 % for each 20ms segment
    seg = sig(i:i+N-1); %split up the signal int' segments of 20ms
    E = [E seg'*seg]; % and follow the sumx^2 equation to find energy. dot product
end

% plot the energy graph and the peak values
figure(2);
clf;
x = 1:length(E);
plot(x,E)
xlabel('Segment number');
ylabel('Energy');
hold on
% Find local maxima
[pks, locs] = findpeaks(E);
plot(locs, pks, 'o');
hold off
figure(3)
plot_spec_dB(E, 1/T); % the dominant frequencies of the drums -these have the greatest energy
figure (4)

% Plot the frequency spectrum of the song
plot_spec_dB(sig, fs);

coords = [pks; locs];


n = 1;
for i = 1:length(pks)
    if coords(1,i) > 169
          beats(1, n) = coords(1, i); % Energies
          beats(2, n) = coords(2, i)*0.02; % Time at which these energies occur
          if n > 1
              beats(3, n) = beats(2, n) - beats(2,n-1); % Calculate time between beats
          end
          n = n + 1;
    else
        continue
    end
end

% Calculate period
period = mean(beats(3,2:end))

% Open the file
choreo = fopen('choreo2.txt','wt');

% Write the moves
moves(choreo, 1, 16, ['f','f', 'b', 'f', 'b', 'f', 'b', 'b'])
moves(choreo, 17, 24, ['o', 'o', 's', 'O', 'O', 's', 'o', 'O'])
moves(choreo, 25, 40, ['l', 's', 'L', 's', 'r', 's', 'R', 's'])
moves(choreo, 41, 48, ['l', 'l', 'r', 'r', 'L', 'L', 'R', 'R'])
moves(choreo, 49, 56, ['r', 'r', 'l', 'l', 'R', 'R', 'L', 'L'])
moves(choreo, 57, 72, ['f', 'l', 'b', 'L', 'f', 'r', 'b', 'R'])
moves(choreo, 73, 84, ['f', 's', 'f', 's', 'b', 's', 'b', 's', 'f', 's', 'b', 's'])
moves(choreo, 85, 100, ['o'])
moves(choreo, 101, 108, ['f','s', 'b', 's'])
moves(choreo, 109, 124, ['l', 's', 'L', 's', 'r', 's', 'R', 's'])
moves(choreo, 125, 132, ['l', 'l', 'r', 'r', 'L', 'L', 'R', 'R'])
moves(choreo, 133, 140, ['r', 'r', 'l', 'l', 'R', 'R', 'L', 'L'])
moves(choreo, 141, 156, ['f', 'l', 'b', 'L', 'f', 'r', 'b', 'R'])
moves(choreo, 157, 168, ['f', 's', 'f', 's', 'b', 's', 'b', 's', 'f', 's', 'b', 's'])
moves(choreo, 169, 184, ['o'])
moves(choreo, 185, 224, ['q', 'q', 'm', 'm', 'm', 'm', 'q', 'q'])
moves(choreo, 225, 232, ['o'])
moves(choreo, 233, 248, ['l', 's', 'L', 's', 'r', 's', 'R', 's'])
moves(choreo, 249, 256, ['l', 'l', 'r', 'r', 'L', 'L', 'R', 'R'])
moves(choreo, 257, 264, ['r', 'r', 'l', 'l', 'R', 'R', 'L', 'L'])
moves(choreo, 265, 280, ['f', 'f', 's', 'b', 'b', 's', 'f', 'b'])
moves(choreo, 281, 292, ['f', 's', 'f', 's', 'b', 's', 'b', 's', 'f', 's', 'b', 's'])
moves(choreo, 293, 308, ['o'])
moves(choreo, 309, 472, ['o', 'f', 'b', 'O'])

% Close the file
fclose(choreo);




