close all

figure; set(gcf,'color','w');
plot(x_dc,y_dc)
hold on

F = polyfit(x_dc,y_dc,8)
y1 = polyval(F,x_dc);

plot(x_dc,y1)

legend('original data','modelled curve');
xlabel('input voltage, x dc (V)');
ylabel('output voltage, y dc (V)');
title('Modelling the behaviour of the system')