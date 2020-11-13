%Simualtion of a complete 6 Degrees of Freedom Model
clc
clear

g = 9.81; %Gravity [m/s^2]
m = 9300; %Mass [kg]
S = 27.8709; % Flugfläche (wing platform area)
si_slug_converter = 1.3558; % Converter Inertia to SI Units
omega_e = 7.29211510*10^(-5); %Rotation Speed of earth [rad/s]
%omega_e =0; 
Omega_e_tilde = vecToMat([0;0;omega_e]);
%Omega_e_tilde = [0 -omega_e 0;omega_e 0 0;0 0 0];
% Inertia of the Plain
Ix = si_slug_converter*9.496;
Ixz = si_slug_converter*982;
Iy = si_slug_converter*55.814;
Iz = si_slug_converter*63.1;
I = [Ix 0 Ixz;0 Iy 0;Ixz 0 Iz]; %Trägheitstensor
I_inv = inv(I);
b = 9.144; %Span [m]
c = 3.45; % Wing Chord [m]

globalParameters.S = S;
globalParameters.b = b;
globalParameters.c = c;
