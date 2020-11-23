%Simualtion of a complete 6 Degrees of Freedom Model
clc
clear
close all
% Get Model Parameters 
[globalParameters,m,g,he,I_inv] = initializeParameters();
%Initial Values
P_e_init = [0;0;1500];
V_init = [250;0;0];
Omega_init = [0;0;0];
Phi_init = [0;0;0];
alpha_init = 0;
beta_init = 0;
X_init = [alpha_init;Omega_init(2);100;Phi_init(2);Omega_init(3);beta_init;Omega_init(1);Phi_init(1); P_e_init(1);P_e_init(2);P_e_init(3);Phi_init(3)];
U_test = [-0.15;0.75;0;0];

%Trim and Lienarisation
%dX =nonlinear_6DOF(X_init,U_test,globalParameters);


