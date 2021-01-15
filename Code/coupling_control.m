function [R, F] = coupling_control(sys,C_tilde,ew,l)
% [R, F] = verkopplung(sys,Cvk,ew,P)
%  berechnet eine Zustandsrückführung u=-Rx+Fw für das System sys, welche die
%  Eigenwerte ew im geschlossenen Regelkreis erzeugt und das System
%  bezüglich des Verkopplungsausgangs 0=Cvk*x verkoppelt. 
%  bei der ausgangsseitigen Verkopplungsbedingung nicht berücksichtigt.
%  F wird für stationäre Genauigkeit ausgelegt, sofern möglich.
% Vorlesung "Mehrgroessenreglerentwurf im Zustandsraum"
% Institut fuer Automatisierungstechnik
% TU Darmstadt

if ~isa(sys,'ss')
    error('sys ist nicht vom Typ ss')
end

ctb1 = steuerbarKalman(sys);
ctb2 = steuerbarHautus(sys);

A = sys.A;
B = sys.B;
C = sys.C;
D = sys.D;
C1_tilde = C_tilde(1:l,:);
C2_tilde = C_tilde(l+1:end,1:end);
% Systemordnung
n = size(A,1);
% Eingangsdimension
p = size(B,2);
% Ausgangssdimension
q = size(C,1);


if ctb1+ctb2~=2
    error('System ist nicht steuerbar!')
end

if any(any(D~=0))
    error('Durchgriff vorhanden')
end

% ausgangsseitige Verkopplungsbedingung für i<m
% m vorab noch nicht bekannt
m = n;

% Matrix der Eigenvektoren
V = zeros(n,n);
P = randn(p,n);

for i = 1:n
    if i<=m
        par = null(C2_tilde*(ew(i)*eye(n)-A)^-1*B);
        V(:,i)=((ew(i)*eye(n)-A)^-1*B)*par(:,3);
        if rank(V)<i
            % ausgangsseitige Verkopplungsbedingung kann nicht weiter
            % angewandt werden
            m = i-1;
            V(:,i)=((ew(i)*eye(n)-A)^-1*B)*P(:,i);
        else
            P(:,i) = par(:,3);
        end
    else
        V(:,i)=((ew(i)*eye(n)-A)^-1*B)*P(:,i);
    end
end

% Regler Matrix R berechenen
R = -P*V^-1;
%R = real(R);
disp(eig(A-B*R))

% Vorfilterentwurf
FM = null([B V(:,1:m)]);
F1 = FM(1:p,:);
F = inv(C_tilde*((B*R - A)\B));
Q_tilde = C1_tilde*((B*R - A)\B*F1);
F1_tilde = F1/Q_tilde;
F(:,1:p-l) = F1_tilde;
