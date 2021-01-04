%Simualtion of a complete 6 Degrees of Freedom Model
clc
clear
close all
% Get Model Parameters 
[globalParameters,m,g,he,I_inv] = initializeParameters();
%Initial Values
h_init_1 = 1000;
P_e_init_1 = [0;0;-h_init_1];
V_init_1 = [70;0;0];
%latlon_init = [40.712776;-74.005974]; %New York
latlon_init = [0;0];
Omega_init_1 = [0;0;0];
Phi_init_1 = [0;0;0];
X_init_1 = [V_init_1;Omega_init_1;Phi_init_1;h_init_1];

%Plain 2
h_init_2 = 1010;
P_e_init_2 = [0;0;-h_init_2];
V_init_2 = [70;0;-10];
Omega_init_2 = [0;0;0];
Phi_init_2 = [0;0.2;0];
X_init_2 = [V_init_2;Omega_init_2;Phi_init_2;h_init_2];
U_test = [-0.12;1;0;0;-0.1;1;0;0];
X_init = [X_init_1;X_init_2];
%Trim and Lienarisation
[X_ap_1,U_ap_1,f0_1] = trimValues(V_init_1(1),h_init_1,1);
[X_ap_2,U_ap_2,f0_2] = trimValues(V_init_2(1),h_init_2,2);
X_ap = [X_ap_1;X_ap_2];
U_ap = [U_ap_1;U_ap_2];
%X_init = X_ap;
%U_test = U_ap;
% %Linearisation

[A_1,B_1] = implicit_linmod(@model_implicit,X_ap_1,U_ap_1,1);
[A_2,B_2] = implicit_linmod(@model_implicit,X_ap_2,U_ap_2,2);
[A,B,C,n] = defineABC(A_1,A_2,B_1,B_2);

%Saturations
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

%Hautus
for i = 1:n
    eig_i = eigenvalues(i);
    if rank([eig_i*eye(n,n)-A;C]) ~=n
        
        disp(['Eigenvalue ',num2str(eig_i),' is not obsarvable ']);
    end
end
%% % Test Controller
  ew_contr = eigenvalues;
  ew_contr(1) = -0.2;
  ew_contr(2) = -0.1;
  ew_contr(10) = -0.09;
  ew_contr(20) = -0.1;
  ew_contr = 5*real(ew_contr);
  K = place(A,B,ew_contr);
  Ak = A -B*K;
  eigenvalues_controlled = 5*eig(Ak);
  F = -inv(C*(Ak\B));
  
  %% Transfer Function Open Loop
  sys_ol = ss(A,B, C,zeros(8,8));
  tf_ol = tf(sys_ol); %Transfer Function
  H = [A B; -C zeros(8,8)];
  E = [eye(n,n) zeros(n,8);zeros(8,n) zeros(8,8)];
  inv_nullpoints = eig(H,E);
  


