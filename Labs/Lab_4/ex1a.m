%% Lab 4 - Exercise 1a
% Using the IMU.

clear all
close all
format compact

pb = PyBench('/dev/tty.usbmodem1422');

if pb.ok()
    display('PyBench is working')
else
    display('PyBench is NOT working')
end

%%

N = 500;
end_time = 10; % define range of x axis, 10 seconds for now

iter = 0;
while iter < 500
    iter = iter + 1;
    figure(1);
    clf(1);
    axis([0, end_time, -90, 90]); % fix axis scaling
    title('Accelerometer Pitch & Roll angles', 'FontSize', 16);
    ylabel('Angle (degrees)', 'FontSize', 14);
    xlabel('Time (sec)', 'FontSize', 14);
    grid on; hold on; % overlay plots on same figure
    
    tic; % define start time
    for i = 1:N
        [p, r] = pb.get_accel(); % pitch and roll in radians
        timestamp = toc; % get time point reading
        pitch = p*180/pi; % radians -> degrees
        roll = r*180/pi;
        
        plot(timestamp,pitch,'.b'); % plot one point
        plot(timestamp,roll,'.r'); % plot another point
        pause(0.001); % delay for 1 millisec
    end
    
    end_time = toc; % update end time - use actual time range from now
end