function [F0] = cost_straight_flight(Z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
X = Z(1:10);
U = Z(11:14);
plain_selector = evalin('base','plain_selector');
h_init =  evalin('base','h_init');
[dX] = nonlinear_6DOF(X,U,plain_selector);

v = X(2);
phi = X(7);
psi = X(9);
h = X(10);

Q = [dX;v;phi;psi;h-h_init];
H = diag(ones(1,14));
F0 = Q'*H*Q;
end

