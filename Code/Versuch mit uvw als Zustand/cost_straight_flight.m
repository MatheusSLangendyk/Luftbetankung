function [F0] = cost_straight_flight(Z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
X = Z(1:15);
U = Z(16:19);
[dX] = nonlinear_6DOF(X,U);
%dX(9) = dX(9) + 250;
vA = X(3);
h = X(11);
beta = X(6);
psi = X(12);

Q = [dX;vA-250;h+2000;beta;psi];
H = diag(ones(1,19));
F0 = Q'*H*Q;
end

