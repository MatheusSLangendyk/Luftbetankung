function [variable_matrix] = vecToMat(variable_vector)
%Transforms a vector to a matrix to enable vector Product
variable_matrix = [0 -variable_vector(3) variable_vector(2);variable_vector(3) 0 -variable_vector(1);-variable_vector(2) variable_vector(1) 0];
end

