function [matrix_transformation] = coordTransfMatrix(angle,type)
% Gives the Transformation matrix T1, T2 or T3 depending on the angle.
% Integer Type defines which of the Matrizes is whished for 


if type == 3
    matrix_transformation = [cos(angle) sin(angle) 0; -sin(angle) cos(angle) 0; 0 0 1];
elseif type == 2
    matrix_transformation = [cos(angle) 0 -sin(angle); 0 1 0; sin(angle) 0 cos(angle)];
elseif type == 1
    matrix_transformation = [1 0 0;0 cos(angle) sin(angle);0 -sin(angle) cos(angle)];
else
    disp('Not a valid Type');
end
end

