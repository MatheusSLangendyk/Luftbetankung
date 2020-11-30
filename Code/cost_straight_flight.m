function [F0] = cost_straight_flight(Z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
X = Z(1:12);
U = Z(13:16);
[dX] = nonlinear_6DOF(X,U);
vA = X(3);
h = X(11);
beta = X(6);
psi = X(12);

Q = [dX;vA-250;h+5000;beta;psi];
H = diag(ones(1,16));
F0 = Q'*H*Q;
end

