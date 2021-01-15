function ctb = steuerbarKalman(sys)
% ctb = steuerbarKalman(sys)
%  berechnet die Steuerbarkeit eines Systems mit dem Kalman-Kriterium
%
%  sys: ss-Objekt
%  ctb: 1, wenn das System steuerbar ist, sonst 0.
%
% Uebung 3): Steuer- und Beobachtbarkeit
% Vorlesung "Mehrgroessenreglerentwurf im Zustandsraum"
% Institut fuer Automatisierungstechnik
% TU Darmstadt

% Systemordnung
n = size(sys.A,1);
% Eingangsdimension
p = size(sys.B,2);

% Steuerbarkeitsmatrix
M = zeros(n,n*p);

for i=1:n
    M(:,(i-1)*p+1:i*p)=sys.A^(i-1)*sys.B;
    rank(M)
end

% Rangüberprüfung
if rank(M)==n
    ctb = 1;
else
    ctb = 0;
end