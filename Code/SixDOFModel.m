%Simualtion of a complete 6 Degrees of Freedom Model
clc
clear
close all
% Get Model Parameters 
[globalParameters,m,g,he,I_inv] = initializeParameters();
%Initial Values
h_init = 1000;
P_e_init = [0;0;-h_init];
V_init = [85;0;0];
%latlon_init = [40.712776;-74.005974]; %New York
latlon_init = [0;0];
vA_init = sqrt(V_init(1)^2+V_init(2)^2+V_init(3)^2);
Omega_init = [0;0;0];
Phi_init = [0;0;0];
alpha_init = 0;
beta_init = 0;
X_init = [V_init;Omega_init;Phi_init;h_init];
U_test = [-0.12;1;0;0];

% %Trim and Lienarisation
[X_ap,U_ap,f0] = trimValues(V_init(1),h_init);
U_test = U_ap;
deltaX_init = X_init-X_ap;
% %Linearisation
[A,B] = implicit_linmod(@model_implicit,X_ap,U_ap);
%Set values under 10e-13 = 0
indices = find(abs(A)<10e-13);
A(indices) = 0;
%Define Outputs
C = zeros(4,10);
C(1,2) = 1; %v-Spped
C(2,3) = 1;%w-Speed
C(3,9) =1; %psi-Angle
C(4,10) = 1;% Height
% %Saturations
eta_max = 10*pi/180; %Elevator
eta_min = - 25*pi/180; 
sigmaf_max = 10*pi/180; %Throttl
sigmaf_min = 0.5*pi/180;
xi_max = 25*pi/180; %Airlon
xi_min = - xi_max;
zita_max = 30*pi/180; %Rudder
zita_min = - zita_max;
% %Contolable/ Obsarvable
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

eigenvalues = eig(A);
n = size(A,1);
%Hautus
% for i = 1:n
%     eig_i = eigenvalues(i);
%     if rank([eig_i*eye(n,n)-A;C]) ~=n
%         
%         disp(['Eigenvalue ',num2str(eig_i),' is not obsarvable ']);
%     end
% end
% % Test Controller
sys = ss(A, B, C, 0);
sys.InputName = {'eta', 'sigmaf', 'xi', 'zeta'};
sys.OutputName = {'v_u', 'v_w', 'psi', 'h'};
ew_contr = eigenvalues;
ew_contr(1) = -0.2;
ew_contr(10) = -0.1;
ew_contr = real(ew_contr);
K = place(A,B,ew_contr);
Ak = A-B*K;
sys_cl = ss(Ak, B, C, 0);
eigenvalues_controlled = eig(Ak);
F = (C*inv(B*K-A)*B);
F = inv(F)
addpath('C:\Users\Markus\Documents\Uni\WISE2021\Projektseminar\gammasyn')