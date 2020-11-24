%Simualtion of a complete 6 Degrees of Freedom Model
clc
clear
close all
% Get Model Parameters 
[globalParameters,m,g,he,I_inv] = initializeParameters();
%Initial Values
P_e_init = [0;0;1000];
V_init = [100;0;0];
vA_init = sqrt(V_init(1)^2+V_init(2)^2+V_init(3)^2);
Omega_init = [0;0;0];
Phi_init = [0;0;0];
alpha_init = 0;
beta_init = 0;
X_init = [alpha_init;Omega_init(2);vA_init;Phi_init(2);Omega_init(3);beta_init;Omega_init(1);Phi_init(1); P_e_init(1);P_e_init(2);P_e_init(3);Phi_init(3)];
U_test = [-0.3;0.2;0;0];

%Trim and Lienarisation
[X_ap,U_ap,f0] = trimValues(vA_init,P_e_init);

%X_init = X_ap;
