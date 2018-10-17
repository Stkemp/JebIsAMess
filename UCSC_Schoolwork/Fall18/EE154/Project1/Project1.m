% EE154 Project 1
% Written by Stephen Kemp
% 

close all;
clear all;
%% Set Constants

S = pi*0.1^2;
A = pi*0.005^2;
B = S^2 - A^2;
g = 9.81;
w = logspace(-6,3,1000);

%% Set Variables and Functions

Y_star = linspace(0.05,0.15,30);
q_star = sqrt(2*A*g*Y_star); % Relationship from part b)

% From part a)
C = sqrt(A^2.*q_star.^2./B^2 + 2.*A^2.*g.*Y_star./B);
% df/dY
a = -A^2.*g./B./C; 
% df/dq
b = S/B - A^2.*q_star./B^2 ./ C;

%% Generate Bode plots
figure(1)
for k = 1:length(a)
    G = tf([b(k)],[1, a(k)]);
    bode(G,w);
    hold on;
end