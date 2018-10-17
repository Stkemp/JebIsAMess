% EE154 Project 1 Matlab Code
% Written by Stephen Kemp
% 

%% Set Constants

S = pi*0.1^2;
A = pi*0.005^2;
g = 9.81;

%% Set Variables and Functions

Y_star = linspace(0.05,0.15,30);
qin_star = sqrt(2*A*g*Y_star); % Relationship from part b)