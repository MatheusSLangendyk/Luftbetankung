function [F0] = cost_straight_flight(Z)
X = Z(1:12);
U = Z(13:16);

dX = nonlinear_6DOF(X,U);
vA = X(3);
h = X(11);
beta = X(6);
psi = X(12);

Q = [dX;
    vA - 100;
    h - 1000;
    beta;
    psi]; % Cost Function
H = diag(ones(1,16)); % Penalty Matrix

F0 = Q'*H*Q; %Cost Matrix

end

