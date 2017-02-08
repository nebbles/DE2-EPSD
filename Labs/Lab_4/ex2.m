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

model = IMU_3D();

N = 50;
tic;
gx = 0; gy = 0;
fig1 = figure(1);

iter = 0;
while iter < 500
    iter = iter + 1;
    
    for i = 1:N
        [p, r] = pb.get_accel(); % pitch and roll in radians
        [x, y, z] = pb.get_gyro(); % pitch and roll in radians
        
        dt = toc; % get incremental time since last tic
        tic; % reset the timer
        
        pitch = p*180/pi; % radians -> degrees
        roll = r*180/pi;
        gx = max(min(gx+x*dt,pi/2),-pi/2);
        gy = max(min(gy+y*dt,pi/2),-pi/2);
        
        clf(fig1);
        subplot(2,1,1);
        model.draw(fig1,p,r,'Accelerometer');
        subplot(2,1,2);
        model.draw(fig1,gy,gx,'Gyroscope');
        
        pause(0.001); % delay for 1 millisec
    end % for loop
end % while loop