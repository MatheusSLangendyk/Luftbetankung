%Simualtion of a complete 6 Degrees of Freedom Model
clc
clear
close all
% Get Model Parameters 
[globalParameters,m,g,he,I_inv] = initializeParameters();
%Initial Values
P_e_init = [100;0;-2000];
V_init = [20;0;0];
vA_init = sqrt(V_init(1)^2+V_init(2)^2+V_init(3)^2);
Omega_init = [0;0;0];
Phi_init = [0;0;0];
alpha_init = 0;
beta_init = 0;
X_init = [alpha_init;Omega_init(2);vA_init;Phi_init(2);Omega_init(3);beta_init;Omega_init(1);Phi_init(1); P_e_init(1);P_e_init(2);P_e_init(3);Phi_init(3);V_init];

U_test = [0.5;1;0;0];

%Trim and Lienarisation
[X_ap,U_ap,f0] = trimValues(vA_init,P_e_init);
% X_init = X_ap;
% U_test = U_ap;
%Linearisation
[A,B] = implicit_linmod(@model_implicit,X_ap,U_ap);
C = zeros(4,15);
C(1,3) = 1;
C(2,4) = 1;
C(3,11) =1;
C(4,12) = 1;
%Saturations
eta_max = 10*pi/180; %Elevator
eta_min = - 25*pi/180; 
sigmaf_max = 10*pi/180; %Throttlw
sigmaf_min = 0.5*pi/180;
xi_max = 25*pi/180; %Airlon
xi_min = - xi_max;
zita_max = 30*pi/180; %Rudder
zita_min = - zita_max;
%Contolable/ Obsarvable
Ms = ctrb(A,B);
Mb = obsv(A,C);
if rank(Ms) ~= min(size(Ms,1),size(Ms,2))
    disp('System is not Kalman Controllable')
else
    disp('System is Kalman Controllable')
end
if rank(Mb) ~= min(size(Mb,1),size(Mb,2))
    disp('System is not Kalman Obsarvable')
else
    disp('System is Kalman Obsarvable')
end
% Stability and Dynamics
eigenvalues = eig(A);
% Test Controller
ew_contr = eigenvalues';
ew_contr(1) = 0.1;
ew_contr(2) = -ew_contr(2);
ew_contr(2) = -0.2;
ew_contr(3) = -0.3;
K = place(A,B,ew_contr);


