clear all
close all
%% part a
filename = 'partAkp1_2.csv'
data = csvread(filename, 5,0);

t = data(:,1);
wmes = data(:,2);
wref = data(:,3);

figure(1);
hold on;
plot(t,wmes);
plot(t,wref);
title('Figure 1, omega tracking for Kp = 1.2, Ki = 0');
xlabel('time(s)');
ylabel('angular velocity(rad/s)')
legend('wmeas', 'wref');
hold off;
%% part b
filename = 'partBkp0ki5.csv'
data = csvread(filename, 5,0);

t = data(:,1);
wmes = data(:,2);
wref = data(:,3);

figure(2);
hold on;
plot(t,wmes);
plot(t,wref);
title('Figure 2, omega tracking for Kp = 0, Ki = 5');
xlabel('time(s)');
ylabel('angular velocity(rad/s)')
legend('wmeas', 'wref');
hold off;

filename = 'partBkp0ki22.csv'
data = csvread(filename, 5,0);

t = data(:,1);
wmes = data(:,2);
wref = data(:,3);

figure(3);
hold on;
plot(t,wmes);
plot(t,wref);
title('Figure 3, omega tracking for Kp = 0, Ki = 22');
xlabel('time(s)');
ylabel('angular velocity(rad/s)')
legend('wmeas', 'wref');
hold off;
%% part c
filename = 'partC.csv'
data = csvread(filename, 5,0);

t = data(:,1);
vmes = data(:,2);
vref = data(:,3);

figure(4);
hold on;
plot(t,vmes);
plot(t,vref);
title('Figure 4, velocity tracking for Kp = 20, Ki = 700');
xlabel('time(s)');
ylabel('velocity(m/s)')
legend('vmeas', 'vref');
hold off;
%% part d
filename = 'partD.csv'
data = csvread(filename, 5,0);

x = data(:,2);
y = data(:,3);

figure(5);
hold on;
plot(x,y);
title('Figure 5, Robot figure-8 trajectory');
xlabel('x(m)');
ylabel('y(m)')
hold off;
