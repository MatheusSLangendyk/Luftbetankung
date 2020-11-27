function [A,B] = implicit_linmod(fun,X_ap,U_ap)
%Number of States and Control
n = length(X_ap); 
m = length(U_ap);

%Definitiion of Perturbation for the Calculation of the Derivative
dX_ap = zeros(n,1);
perturbation = 10e-12;
E = zeros(n,n);
A_prime = zeros(n,n);
B_prime = zeros(n,m);
%Fill all Jakobi Matrix Elements ---> Calculate A_prime and E
for i =1:n
    for j = 1:n
        %Evaulation of the implicit function for the E Matrix
        dX_perturbation = dX_ap;
        dX_perturbation(j) = perturbation;
        F = feval(fun, dX_perturbation,X_ap,U_ap);
        F_plus = F(i);
        F = feval(fun, -dX_perturbation,X_ap,U_ap);
        F_minus = F(i);
        E(i,j) = (F_plus - F_minus)/(2*perturbation);
        %Evaulation of the implicit function for the A_prime Matrix
        X_plus = X_ap;
        X_minus = X_ap;
        X_plus(j) = X_plus(j) + perturbation;
        X_minus(j) = X_minus(j) - perturbation;
        F = feval(fun, dX_ap, X_plus,U_ap);
        F_plus = F(i);
        F = feval(fun, dX_ap, X_minus,U_ap);
        F_minus = F(i);
        A_prime(i,j) = (F_plus - F_minus)/(2*perturbation);
        
    end
end
for i =1:n
    for j = 1:m
        U_plus = U_ap;
        U_minus = U_ap;
        U_plus(j) = U_plus(j) + perturbation;
        U_minus(j) = U_minus(j) - perturbation;
        F = feval(fun, dX_ap, X_ap, U_plus);
        F_plus = F(i);
        F = feval(fun, dX_ap, X_ap, U_minus);
        F_minus = F(i);
        B_prime(i,j) = (F_plus - F_minus)/(2*perturbation);
    end
end
A = -inv(E)*A_prime;
B = -inv(E)*B_prime;


end

