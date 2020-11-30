function [dX] = nonlinear_6DOF(X,U)
%--------------States------------%
alpha = X(1);
q = X(2);
vA = X(3);
theta = X(4);
r = X(5);
beta = X(6);
p = X(7);
phi = X(8);
x = X(9);
y = X(10);
z = X(11);
psi = X(12);

%--------------Control------------%
eta = U(1);
sigmaf = U(2);
xi = U(3);
zita = U(4);

%--------------Constants------------%
[globalParameters,m,g,~,I_inv] = initializeParameters();
rho_const = globalParameters.rho_const ;
Omega_e_tilde = globalParameters.Omega_e_tilde ;
I = globalParameters.I ;
S = globalParameters.S ;
St = globalParameters.St ;
lt = globalParameters.lt ;
b = globalParameters.b ;
c = globalParameters.c ;
P_thrust = globalParameters.P_thrust ;
P_centerGravity = globalParameters.P_centerGravity ;
P_aerodynCenter = globalParameters.P_aerodynCenter ;
i_f = globalParameters.i_f ;
F_max = globalParameters.Fmax;
% Airdynamical Coefficients
CA0 = 1.104;
grad_alpha = 5.5;
alpha_L0 = 11.5*pi/180;
% a3 = -768.5;
% a2 = 609.2;
% a1 = -155.2;
% a0 = 15.212;
gradient_alpha_epsolon = 0.25;
gradient_CQ_Cbeta = -1.6;
gradientCQ_Czita = 0.24;
CW0 = 0.13;
kappa = 0.07;


%--------------Variables------------%
q_d = 0.5*rho_const*vA^2; %Dynamic Preassure
Omega = [p;q;r];
VA = vA*[sqrt((1-sin(beta)^2)/(1+tan(alpha)^2));sin(beta);tan(alpha)*sqrt((1-sin(beta)^2)/(1+tan(alpha)^2))];

%--------------Aerodynamical Coefficients------------%
%Forces Coefficients
%if alpha <=14.5*pi/180
    CA_F = grad_alpha*alpha+CA0; % Lift Coefficient without the Control Aereas
% else
%     CA_F = a3*alpha^.3+a2*alpha^.2+a1*alpha +a0;% Lift Coefficient without the Control Aereas
% end
epsolon = gradient_alpha_epsolon*(alpha - alpha_L0); %Downwash [rad]
alpha_t = alpha - epsolon + eta +q*lt/vA; %Angle of Attack of the Tail [rad]
CA_H = 3.1*(St/S)*alpha_t; %Lift Coefficient of the Control Aereas (Elevator-Tail)
CA = CA_F + CA_H; %Total Lift Coefficient
CW = CW0 + kappa*(5.5*alpha + 0.654)^2; %Drag Coefficient
CQ = gradient_CQ_Cbeta*beta + gradientCQ_Czita*zita;

%Moments Coefficients
N = [-1.4*beta;-0.59-3.1*(St*lt/(c*S))*(alpha-epsolon);(1-alpha*(180/(15*pi)))*beta]; %Static Moments Effects
Jakobi_CM_X = (c/vA)*[-11,    0,           5;
                      0,-4.03*St*lt^2/(S*c),0;
                      1.7,          0   , -11.5];
Jakobi_CM_U = [-0.6, 0, 0.22;
               0,    -3.1*St*lt/(S*c),0;
               0, 0, -0.63];      % Dependence of Control Variables
           
C_torque = N + Jakobi_CM_X*Omega + Jakobi_CM_U*[xi;eta;zita];
CL = C_torque(1);
CM = C_torque(2);
CN = C_torque(3);

%-------------- Forces and Moments ------------%
%Aerodynamics
A = q_d*S*CA; %Lift Force [N]
W = q_d*S*CW; %Air Resistance [N]
Q = q_d*S*CQ; %Transverse Force [N]

Tfa = coordTransfMatrix(alpha,2)*coordTransfMatrix(-beta,3); %Transformation Matrix Aerodynamics -> Körperfest

RA_a =[-W;Q;-A]; %Aerodynamical Force in Aerdodynamical Reference Frame
RA = Tfa*RA_a; %Aerodynamical Force in Body Reference Frame

QA_aerodynCenter = q_d*S*[0.5*b*CL;c*CM;0.5*b*CN]; %Torque on the aerodynamical Center
QA = QA_aerodynCenter + vecToMat(P_centerGravity- P_aerodynCenter)*RA; %Aerodynamical Force in Body Reference Frame

%Thrust
F_res = F_max*sigmaf; %Thrust Force Absolute Value
Rf = F_res*[cos(i_f);0;sin(i_f)]; %Thrust Force 
P_thrust_tilde = vecToMat(P_thrust);
Qf = P_thrust_tilde*Rf; %Thrust Moment

Q_total = Qf + QA; %Sum of external Moments in Body reference Frame [Nm]
R_total = RA + Rf; %Sum of external Forces in Body reference Frame [N]

%-------------- Equations of Motion ------------%
%Dynamic
Tfg =  coordTransfMatrix(phi,1)*coordTransfMatrix(theta,2)*coordTransfMatrix(psi,3); % Transformation Matrix goedetic --> body reference Frame
Omega_tilde = vecToMat(Omega);

V = VA; %Under negletance of the Wind
dOmega = I_inv*(Q_total - Omega_tilde*I*Omega); %Derivative of Rotation Rate (body Reference Frame)
dV = R_total/m + Tfg*[0;0;g] - (Omega_tilde + Omega_e_tilde)*V; %Derivatitive of the Speed (body Reference Frame)
dvA = (V(1)*dV(1) + V(2)*dV(2) +V(3)*dV(3))/(vA); %Derivative of the Approach Speed
dalpha = (dV(3)*V(1)-dV(1)*V(3))/(V(1)^2+V(1)*V(3)); %Derivative of Angle of Attack
dbeta = (dV(2)*vA -dvA*V(2))/(vA*sqrt(vA^2-V(2)^2)); %Derivative of Sideslip Angle
dp = dOmega(1); %Yield Angular Acceleration 
dq = dOmega(2); %Pitch Angular Acceleration 
dr = dOmega(3);%Yaw Angular Acceleration 
%Kinematics
lambda = atan2(y,x); %Angle Längengrad
sigma = asin(z/sqrt(x^2+y^2+z^2)); %Declination Angle 
TgE = coordTransfMatrix(-pi/2 - sigma,2)*coordTransfMatrix(lambda,3);
TfE = Tfg*TgE;
TEf= TfE';
dP_e = TEf*V;
dx = dP_e(1); %Derivative of x-position (earth Reference Frame)
dy = dP_e(2); %Derivative of y-position (earth Reference Frame)
dz = dP_e(3); %Derivative of z-position (earth Reference Frame)
J = 1/cos(theta)*[cos(theta) sin(phi)*sin(theta) cos(phi)*sin(theta) ;0 cos(phi)*cos(theta) -sin(phi)*cos(theta);0 sin(phi) cos(phi)]; %Rotation rate matrix
dPhi = J*Omega; %Derivative of Euler Angles
dphi = dPhi(1); 
dtheta = dPhi(2);
dpsi = dPhi(3);
dX = [dalpha;dq;dvA;dtheta;dr;dbeta;dp;dphi;dx;dy;dz;dpsi];

end



