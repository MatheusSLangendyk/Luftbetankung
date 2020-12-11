function [FVAL] = model_implicit(dX,X,U)
%Organize the non-linear model in an implicit form 
plain_selector = evalin('base','plain_selector');
FVAL = nonlinear_6DOF(X,U,plain_selector) - dX;
end

