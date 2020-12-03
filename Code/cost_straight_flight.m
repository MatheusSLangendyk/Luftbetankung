function [F0] = cost_straight_flight(Z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
X = Z(1:10);
U = Z(11:14);
[dX] = nonlinear_6DOF(X,U);

v = X(2);
phi = X(7);
psi = X(9);
h = X(10);

Q = [dX;v;phi;psi;h-2000];
H = diag(ones(1,14));
F0 = Q'*H*Q;
end

