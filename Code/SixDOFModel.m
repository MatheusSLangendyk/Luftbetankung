%Simualtion of a complete 6 Degrees of Freedom Model
clc
clear
close all
%Parameters from a Boeing 757 dash 200
g = 9.81; %Gravity [m/s^2]
m = 120000; %Mass [kg]
% Modelling the atmosphere (TODO)
rho = 1.25; %Air denisty [kg(m^3]
%a = 343; %Speed of sound [m/s];
mach = 0.09; % Mesh Number
omega_e = 7.29211510*10^(-5); %Rotation Speed of earth [rad/s]
%omega_e =0; 
Omega_e_tilde = vecToMat([0;0;omega_e]);
% Inertia and Paramethers of the Plain
S = 260; % Flugfläche (wing platform area)
St = 64; %Aerea of the Tail [m^2] 
lt = 24.8; %Length to tail [m] (estimation)
%Moments of Inertia of Boeing 757-200 [kg(m^2]
Ix = 10710000; % 
Ixz = 0; 
Iy = 14883800; 
Iz = 25283271; 
I = [Ix 0 Ixz;0 Iy 0;Ixz 0 Iz]; %Trägheitstensor
I_inv = inv(I);
b = 38.05; %Span [m] 
c = 6.5; % Wing Chord [m]
%Aerodynamical Positions
P_centerGravity = [0.23*c;0;0.1*c];
P_aerodynCenter = [0.12*c;0;0];


%Motor and Thrust
P_thrust = [0.23*c;0;0.1*c+1.9]; %Position of the motor [m] 
i_f = pi/100; %Direction of Thrus [rad];
F_max = 2*128000; %Maximale Schubkraft ohne Nachbrenner [N]

globalParameters.S = S;
globalParameters.St = St;
globalParameters.lt = lt;
globalParameters.b = b;
globalParameters.c = c;
globalParameters.rho = rho;
globalParameters.P_thrust =P_thrust;
globalParameters.P_centerGravity = P_centerGravity;
globalParameters.P_aerodynCenter = P_aerodynCenter;
globalParameters.i_f =i_f;
globalParameters.Fmax = F_max;

%Initial Values
P_e_init = [0;0;1000];
V_init = [100;0;10];
Omega_init = [0;0;0];
Phi_init = [pi/20;0;pi/10];
alpha_init = pi/20;
beta_init = 0;

Jakobi_CM_U = [-0.6, 0, 0.22;
               0,    -3.1*St*lt/(S*c),0;
               0, 0, -0.63];      % Dependence of Control Variables

%%% CA Test
% alpha = -pi/6:0.01:pi/6;
% n = 5.5;
% a3 = -768.5;
% a2 = 609.2;
% a1 = -155.2;
% a0 = 15.212;
% alphaL0 = -11.5*pi/180;
% CA0 = 1.1;
% CA = zeros(1,size(alpha,2));
% for a =1:size(alpha,2)
%     if alpha(a) <= 14.5*pi/180
%         CA(a) = n*alpha(a) + CA0;
%     else
%         CA(a) = a3*alpha(a).^3 +a2*alpha(a).^2+a1*alpha(a)+a0;
%     end
% end
% %CA = a3*alpha.^3 +a2*alpha.^2+a1*alpha+a0;
% plot(alpha,CA)
% grid on;

