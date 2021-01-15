function [ctb, ewS, ewNS] = steuerbarHautus(sys)
% [ctb, ewS, ewNS] = steuerbarHautus(sys)
%  berechnet die Steuerbarkeit eines Systems mit dem Hautus-Kriterium
%
%  sys: ss-Objekt
%  ctb: 1, wenn das System steuerbar ist, sonst 0.
%  ewS:  alle steuerbaren Eigenwerte
%  ewNS: alle nichtsteuerbaren Eigenwerte
%
% Uebung 3): Steuer- und Beobachtbarkeit
% Vorlesung "Mehrgroessenreglerentwurf im Zustandsraum"
% Institut fuer Automatisierungstechnik
% TU Darmstadt

A = sys.A;
B = sys.B;

% Systemordnung
n = size(A,1);
% Eigenwerte
lambda = eig(A);

% initialisieren
ctb = 1;
ewS = zeros(0);
ewNS = zeros(0);

for i=1:n
    M=[lambda(i)*eye(n)-A, B];
    if rank(M)==n
        ewS(end+1,1) = lambda(i);
    else
        ctb = 0;
        ewNS(end+1,1) = lambda(i);
    end
end