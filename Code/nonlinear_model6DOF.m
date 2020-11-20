function [f] = nonlinear_model6DOF(globalParameters)
syms  alph q vA theta r  bet p phi x y z ps%States
syms eta sigmaf xi zita %Control
syms v1 v2 v3 %Help Variables
%Constants 
g = globalParameters.g ;
m = globalParameters.m ;
rho_const = globalParameters.rho_const ;
Omega_e_tilde = globalParameters.Omega_e_tilde ;
I = globalParameters.I ;
I_inv = globalParameters.I_inv ;
S = globalParameters.S ;
St = globalParameters.St ;
lt = globalParameters.lt ;
b = globalParameters.b ;
c = globalParameters.c ;
P_thrust = globalParameters.P_thrust ;
P_centerGravity = globalParameters.P_centerGravity ;
P_aerodynCenter = globalParameters.P_aerodynCenter ;
i_F = globalParameters.i_f ;
F_max = globalParameters.Fmax;
% Airdynamical Coefficients
CA0 = 1.104;
grad_alpha = 5.5;
alpha_L0 = 11.5*pi/180;
a3 = -768.5;
a2 = 609.2;
a1 = -155.2;
a0 = 15.212;
gradient_alpha_epsolon = 0.25;
gradient_CQ_Cbeta = -1.6;
gradientCQ_Czita = 0.24;
CW0 = 0.13;
kappa = 0.07;

%Transformation Matrix
Tfg = coordTransfMatrix(phi,1)*coordTransfMatrix(theta,2)*coordTransfMatrix(ps,3); % Transformation Matrix goedetic --> body reference Frame


Omega = [p;q;r]; %Rotation rates (body reference frame)
V = [v1;v2;v3]; % Aircraft Velocity (body Reference Frame)
Omega_tilde = vecToMat(Omega);

%Dynamical System
dV = 1/m*(RA+Rf) + Tfg*[0;0;g] - (Omega_tilde + Omega_e_tilde)*V;
dOmega = I\((QA + Qf) - Omega_tilde*I*Omega);

%Output
dp = dOmega(1);
dq = dOmega(2);
dr = dOmega(3);

f = [dalpha; dq; dvA; dtheta; dr; dbeta; dp; dphi; dx; dy; dz];
end

