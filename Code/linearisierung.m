function [A, B, C, D] = linearisierung(f, h, AP)
syms x y z Vk chsi gama%States
syms alpha_angle my sigmaf %Inputs

% Zustands- und Eingangsvektoren
X = [x y z Vk chsi gama];
U = [alpha_angle my sigmaf];


% Ableitungen
A = jacobian(f, X);
B = jacobian(f, U);
C = jacobian(h, X);
D = jacobian(h, U);


% Arbeitspunkt des Momentes M
%f_subs = subs(f, X, AP);
%U_ap = solve(f_subs, U);
U_ap = [0,0,0];


% Arbeitspunkt der Matrizen
A = subs(A, [X, U], [AP, U_ap]);
B = subs(B,[X, U], [AP, U_ap]);
C = subs(C, [X, U], [AP, U_ap]);
D = subs(D,[X, U], [AP, U_ap]);

A = double(A);
B = double(B);
C = double(C);
D = double(D);

end

