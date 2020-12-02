function [X_ap,U_ap,f0] = trimValues(vA_init,P_e_init)
%Find the Trim Point under given Conditions
%AP (equilibrium Points of the System)
%Initialize z_guess: 0 wheather start from Initial guess. 1 wheather use
%values from last run

Z_guess = zeros(19,1);
Z_guess(3) = vA_init; 
Z_guess(11) = P_e_init(3);
f_prev = inf;
f0 = inf;
while f0 > 10e-5
    
    [Z_ap,f0] = fminsearch('cost_straight_flight',Z_guess,optimset('TolX',1e-10,'MaxFunEvals',10000,'MaxIter',10000));
     if (f0-f_prev)^2 < 10e-10
         break
     end
     f_prev = f0;
     Z_guess = Z_ap;
         
end
X_ap = Z_ap(1:15);
U_ap = Z_ap(16:19);

end