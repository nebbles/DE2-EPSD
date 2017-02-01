%% Lab 3 - Exercise 1
% Start by using standard start script commands.

% clear all
close all
format compact

pb = PyBench('/dev/tty.usbmodem1412');

if pb.ok()
    display('PyBench is working')
else
    display('PyBench is NOT working')
end

%% Testing the closed bulb system
% We can set the voltage of input to the closed bulb system and measure
% (after waiting for system to return to static state) the output voltage
% from the closed system. We comment out to run the later code.

% pb.dc(3.0); % set x_dc value
% pause(2); % this is to give the system time to react and get to eqivalent y_dc
% pb.get_one() % read the y_dc value

%% Collecting data on the static behaviour of the system
% The behaviour of the system will result in a certain output voltage for
% each input voltage we pass in. This is all for static state and so we
% must pause between each voltage change to ensure the system can 'catch
% up' otherwise we are measuring it in a dynamic state.

x_dc = 0:0.05:3;
y_dc = zeros(1,length(x_dc));

for i=1:length(x_dc);
    x_dc(i) % display the current x_dc value to command line
    pb.dc(x_dc(i)); % set x_dc value
    pause(1); % this is to give the system time to react and get to eqivalent y_dc
    y_dc(i) = pb.get_one() % read the y_dc value and display
end

% Use polyfit to model the coefficient of an 8th degree polynomial
F = polyfit(x_dc,y_dc,8);
% Find the y values of our 8th degree polynomial function using x_dc
y1 = polyval(F,x_dc);


figure; set(gcf,'color','w');
plot(x_dc,y_dc);
title('Lab 3 Exercise 1');
ylabel('y dc (V)');
xlabel('x dc (V)');

hold on;
plot(x_dc,y1); % demonstrate that the model F(x) fits over the original
legend('original data','modelled curve');



