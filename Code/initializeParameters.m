function [globalParameters,m,g,he,I_inv] = initializeParameters()
%Function initializes all Constants of the Model
%Parameters from a Boeing 757 dash 200
g = 9.81; %Gravity [m/s^2]
m = 120000; %Mass [kg]

% Modelling the atmosphere 
rho_const = 1.25; %Airdensity (simplification)
omega_e = 7.29211510*10^(-5); %Rotation Speed of earth [rad/s]
he = 6356752; %Earth radius [m]
Omega_e_tilde = vecToMat([0;0;omega_e]);

% Inertia and Paramethers of the Plain
S = 260; % Flugfläche (wing platform area)
St = 64; %Aerea of the Tail [m^2] 
lt = 24.8; %Length to tail [m] (estimation)

%Moments of Inertia of Boeing 757-200 [kg(m^2]
Ix = 10710000; % 
Ixz = 0; 
Iy = 14883800; Iz = 25283271; 
I = [Ix 0 Ixz;0 Iy 0;Ixz 0 Iz]; %Trägheitstensor
I_inv = inv(I);

b = 38.05; %Span [m] 
c = 6.5; % Wing Chord [m]

%Aerodynamical Positions
P_centerGravity = [0.23*c;0;0.1*c];
P_aerodynCenter = [0.12*c;0;0];




%Motor and Thrust
P_thrust = [0.23*c;0;0.1*c+1.9]; %Position of the motor [m] 
i_f = 0 ; %Direction of Thrus [rad];
F_max = 2*128000; %Maximale Schubkraft ohne Nachbrenner [N]

globalParameters.g = g;
globalParameters.m = m;
globalParameters.Omega_e_tilde = Omega_e_tilde;
globalParameters.rho_const = rho_const;
globalParameters.I = I;
globalParameters.I_inv = I_inv;
globalParameters.S = S;
globalParameters.St = St;
globalParameters.lt = lt;
globalParameters.b = b;
globalParameters.c = c;
globalParameters.P_thrust =P_thrust;
globalParameters.P_centerGravity = P_centerGravity;
globalParameters.P_aerodynCenter = P_aerodynCenter;
globalParameters.i_f =i_f;
globalParameters.Fmax = F_max;
end

