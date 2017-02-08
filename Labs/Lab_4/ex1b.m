%% Lab 4 - Exercise 1b
% Using the gyroscope.

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
gx = 0;
gy = 0;

iter = 0;
while iter < 500
    iter = iter + 1;
    
    figure(1);
    clf(1);
    axis([0, end_time, -90, 90]); % fix axis scaling
    title('Gyroscope Pitch & Roll angles', 'FontSize', 16);
    ylabel('Angle (degrees)', 'FontSize', 14);
    xlabel('Time (sec)', 'FontSize', 14);
    grid on; hold on; % overlay plots on same figure
    
    timestamp = 0;
    tic; % define start time
    
    for i = 1:N
        [x, y, z] = pb.get_gyro(); % pitch and roll in radians
        dt = toc; % get incremental time since last tic
        tic; % reset the timer
        timestamp = timestamp + dt; % timestamp is cumulative time intervals
        gx = max(min(gx+x*dt,pi/2),-pi/2);
        gy = max(min(gy+y*dt,pi/2),-pi/2);
        
        plot(timestamp,gy*180/pi,'.b'); % plot one point
        plot(timestamp,gx*180/pi,'.r'); % plot another point
        pause(0.001); % delay for 1 millisec
    end % for loop
    
    end_time = timestamp;
end % while loop