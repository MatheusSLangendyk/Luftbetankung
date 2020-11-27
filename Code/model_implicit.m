function [FVAL] = model_implicit(dX,X,U)
%Organize the non-linear model in an implicit form 
FVAL = nonlinear_6DOF(X,U) - dX;
end

