function [f, h] = nonlinear_model(globalConstants)
syms x y z Vk chsi gama %Zustände
syms alpha_angle my sigmaf %Eingänge
%Constants
g = globalConstants.g; %Gravity
m = globalConstants.m; % Mass
CA_0 = globalConstants.CA_0;
CA_alpha = globalConstants.CA_alpha;
kw = globalConstants.kw;
F_max = globalConstants.F_max;
rho = globalConstants.rho;
S = globalConstants.S;

%Beiwerte
q = 0.5*rho*Vk^2; %Staudruck (back pressure)
CA = CA_0 +alpha_angle*CA_alpha;
CW = kw*CA^2;
%Forces
F =F_max*sin(sigmaf);
A = q*S*CA;
W = q*S*CW;
%Q = 0;

%Dynamics
    f = [Vk*cos(chsi)*cos(gama);
        Vk*sin(chsi)*cos(gama);
        - Vk*sin(gama);
        (F*cos(alpha_angle)-W)/m - g*sin(gama);
        1/(m*Vk*cos(gama))*(A*sin(my)+ F*sin(my)*sin(alpha_angle));
        (cos(my))/(Vk*m)*(A+F*sin(alpha_angle))-g*cos(gama)/Vk];

     h = [x;
         y;
         z;
         Vk;
         chsi;
         gama];
end

