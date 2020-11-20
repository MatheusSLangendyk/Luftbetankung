clear
clc
%Simulation of a F-16 as Point of mass model
%Global Constants
g = 9.81; %Gravity [m/s^2]
m = 9300; %Mass [kg]
S = 27.8709; % Flugfläche (wing platform area)
CA_0 = 0.15;% Initialauftriebwert für Maschzahl = 0.8
CA_alpha = 0.0888; %Gradient Auftriebwert für Maschzahl = 0.8
kw = 1/CA_alpha; %Auftriebswellenwiderstand Coefficient
F_max = 76310; %Maximale Schubkraft ohne Nachbrenner
[~,~,~,rho] = atmosisa(2000);% Atmosphere air density
%global globalConstants
globalConstants.g = g;
globalConstants.m = m;
globalConstants.S = S;
globalConstants.CA_0 = CA_0;
globalConstants.CA_alpha = CA_alpha;
globalConstants.kw = kw;
globalConstants.F_max = F_max;
globalConstants.rho = rho;

%assignin('base','globalConstants',globalConstants);

% Initiial Values
X_init(1) = 0; %x-position (geod. Reference Frame) [m]
X_init(2) = 0; %y-position (geod. Reference Frame) [m]
X_init(3) = -2000; %y-position (geod. Reference Frame) [m]
X_init(4) = 153; %Bahngeschwindigkeit [m/s]
X_init(5) = pi/20; %Bahnazimut [rad]
X_init(6) = pi/20; %Bahnneigungswinkel [rad]
%Working Points
AP = [100,100,2000,200,pi/10,pi/10];

%Linearization
[f, h] = nonlinear_model(globalConstants);
[A, B, C, D] = linearisierung(f, h, AP);

%Stationary Input Values
alpha_stat = 0.08; %Angle of Attack [rad]
sigmaf_stat = pi/4; %Schubhebstellung [rad]
my_stat = 0.01; %Hängewinkel [rad]


T_start = 20; %Zeit zum Eingangaufschlag
