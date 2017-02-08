%% Lab 4 - Exercise 1b (v2)
% Viewing the IMU and the gyroscope.

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
end_time_imu = 30; % define range of x axis, 10 seconds for now
end_time_gyro = 30;
gx = 0; gy = 0;

iter = 0;
while iter < 500
    iter = iter + 1;
    
    figure(1);
    clf(1);
    
    subplot(2,1,1);
    axis([0, end_time_imu, -90, 90]); % fix axis scaling
    title('Accelerometer Pitch & Roll angles', 'FontSize', 16);
    ylabel('Angle (degrees)', 'FontSize', 14);
    xlabel('Time (sec)', 'FontSize', 14);
    grid on; hold on; % overlay plots on same figure
    
    subplot(2,1,2);
    axis([0, end_time_gyro, -90, 90]); % fix axis scaling
    title('Gyroscope Pitch & Roll angles', 'FontSize', 16);
    ylabel('Angle (degrees)', 'FontSize', 14);
    xlabel('Time (sec)', 'FontSize', 14);
    grid on; hold on; % overlay plots on same figure
    
    timestamp = 0;
    tic; % define start time
    previous = toc; % define an intial 'previous' value
    
    for i = 1:N
        
        [p, r] = pb.get_accel(); % pitch and roll in radians
        timestamp = toc; % get time point reading
        pitch = p*180/pi; % radians -> degrees
        roll = r*180/pi;
        
        subplot(2,1,1)
        plot(timestamp,pitch,'.b'); % plot one point
        plot(timestamp,roll,'.r'); % plot another point
        
        
        
        
        [x, y, z] = pb.get_gyro(); % pitch and roll in radians
        dt = toc - previous; % take interval since last pass
        previous = toc; % set wht the last pass was 
        
        timestamp = timestamp + dt; % timestamp is cumulative time intervals
        gx = max(min(gx+x*dt,pi/2),-pi/2);
        gy = max(min(gy+y*dt,pi/2),-pi/2);
        
        subplot(2,1,2);
        plot(timestamp,gy*180/pi,'.b'); % plot one point
        plot(timestamp,gx*180/pi,'.r'); % plot another point
        
        pause(0.001); % delay for 1 millisec
    end % for loop
    
    end_time_imu = toc; % update end time - use actual time range from now
    end_time_gyro = timestamp;
    
end % while loop