clear; close all;
addpath('gammasyn');  
startup;
%% Settings
SixDOFModel;
C_tilde = zeros(8,20);
C_tilde(1:3, 1:3) = eye(3);
C_tilde(4,10) = 1;
C_tilde(5,1) = 1;
C_tilde(5,11) = -1;
C_tilde(6,2) = 1;
C_tilde(6,12) = -1;
C_tilde(7,3) = 1;
C_tilde(7,13) = -1;
C_tilde(8,10) = 1;
C_tilde(8,20) = -1;
polen = eig(A);
polen(find(eig(A) >= 0)) = -0.2*ones(length(find(eig(A) >= 0)),1);
polen = real(polen);
R_0 = place(A,B,polen);
K_0 = [];
F_0 = eye(8);
RKF_0 = {R_0, K_0, F_0};

system = struct('A', A, 'B', B, 'C', eye(size(A,1)), 'C_ref', C_tilde);
system_properties = struct(...
		'number_states',				n,...
		'number_controls',				8,...
		'number_couplingconditions',	4,...
		'number_models',				1,...
        'RKF_0',						{RKF_0}...
	);
% EXACT								structurally constrained controller only EXAKT solution
% APPROXIMATE						structurally constrained controller also approximate solution
% NUMERIC_NONLINEAR_EQUALITY		fully numeric design with non-linear equality constraints
% NUMERIC_NONLINEAR_INEQUALITY		fully numeric design with non-linear inequality constraints

% control_design_type = GammaCouplingStrategy.EXACT;
control_design_type = GammaCouplingStrategy.APPROXIMATE;
% control_design_type = GammaCouplingStrategy.NUMERIC_NONLINEAR_EQUALITY;
% control_design_type = GammaCouplingStrategy.NUMERIC_NONLINEAR_INEQUALITY;

tolerance_NUMERIC_NONLINEAR_INEQUALITY = 0.001;

%% pole area parameters
a = 0.01;
b = 0.01;
r = 5;

%% gammasyn options
solver = optimization.solver.Optimizer.FMINCON; %FMINCON;% solver to use
options = optimization.options.OptionFactory.instance.options(solver,...
    'ProblemType',                  optimization.options.ProblemType.UNCONSTRAINED,...
	'Retries',						1,...											% number of retries
	'Algorithm',					solver.getDefaultAlgorithm(),...				% algorithm of solver, for not builtin solvers name of the solver, e.g. 'snopt' for SNOPT
	'FunctionTolerance',			1E-5,...
	'StepTolerance',				1E-5,...
	'ConstraintTolerance',			1.4e-5,...
	'MaxFunctionEvaluations',		5E3,...
	'MaxIterations',				5E3,...
	'MaxSQPIter',					5E3,...
	'SpecifyObjectiveGradient',		true,...
	'SpecifyConstraintGradient',	true,...
	'CheckGradients',				false,...
	'FunValCheck',					false,...
	'FiniteDifferenceType',			'forward',...
	'Diagnostics',					false,...
	'Display',						'iter-detailed'...
	);
objectiveoptions = struct(...
	'usecompiled',				true,...											% indicator, if compiled functions should be used
	'type',						GammaJType.LINEAR,...								% type of pole area weighting in objective function
	'allowvarorder',			false,...											% allow variable state number for different multi models
	'eigenvaluederivative',		GammaEigenvalueDerivativeType.VANDERAA,...
	'errorhandler',				GammaErrorHandler.ERROR,...
	'strategy',					GammaSolutionStrategy.SINGLESHOT...
	);

%% Pole area
weight = 1;
polearea = [control.design.gamma.area.Circle(r), control.design.gamma.area.Hyperbola(a, b)];

%% gammasyn_couplingcontrol
objectiveoptions.couplingcontrol.couplingstrategy = control_design_type;
objectiveoptions.couplingcontrol.tolerance_coupling = tolerance_NUMERIC_NONLINEAR_INEQUALITY;
objectiveoptions.couplingcontrol.couplingconditions = uint32(system_properties.number_couplingconditions);
objectiveoptions.couplingcontrol.solvesymbolic = true;
objectiveoptions.couplingcontrol.round_equations_to_digits = 5;
objectiveoptions.couplingcontrol.sortingstrategy_coupling = [];
[Kopt, Jopt, information] = control.design.gamma.gammasyn_couplingcontrol(system, polearea, weight, [], system_properties.RKF_0, options, objectiveoptions);
if isempty(Kopt)
	return;
end

R = Kopt{1}
F = Kopt{end}
information

%% Analysis
if ~any(any(isnan(R)))
	[gain_ratio, ~, poles_all, F] = test.develop.analyze_results(systems, Kopt, polearea, system_properties.number_couplingconditions);
	Kopt{end} = F;
	minimal_deviation = 100/min(abs(gain_ratio))
end