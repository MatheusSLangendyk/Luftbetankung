function [A,B,C,n] = defineABC(A_1,A_2,B_1,B_2)
n = size(A_1,1) +size(A_2,2);
m = size(B_1,2) + size(B_2,2);
A = [A_1 zeros(n/2,n/2);zeros(n/2,n/2) A_2];
B = [B_1, zeros(n/2,m/2);zeros(n/2,m/2), B_2];

%Set values under 10e-13 = 0

%A(find(abs(A)<10e-13)) = 0;
A((abs(A)<10e-13)) = 0;

C = zeros(m,n);
C(1,1) = 1; %u-Spped
C(1,11) = -1;
C(2,2) = 1; %v-Spped
C(2,12) = -1;
C(3,3) = 1; %w-Spped
C(3,13) = -1;
C(4,6) = 1; %q-rot Spped
C(4,16) = 1;
C(5,7) = 1; %phi-Spped
C(5,17) = -1;
C(6,8) = 1; %theta-Spped
C(6,18) = -1;
C(7,9) = 1; %psi-Spped
C(7,19) = -1;
C(8,10) = 1; %h-Spped
C(8,20) = -1;
end

