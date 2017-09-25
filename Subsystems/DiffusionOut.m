%% 18/08/2017 Miroslav Gasparek
%% SimBiology Model of diffusion into vesicle for subsystem framework in TX-TL

function SubsystemModelObj = DiffusionOut
% clear, clc, close all
SubsystemModelObj = sbiomodel('DiffusionOut');
% Set up the parameters for the simulation
csObj = getconfigset(SubsystemModelObj);
csObj.CompileOptions.DimensionalAnalysis = false;
csObj.SolverType = 'ode15s';
csObj.StopTime   = 20;      % Specified runtime to be 20s
csObj.RuntimeOptions.StatesToLog = 'all';

ves = addcompartment(SubsystemModelObj,'ves');
ves.CapacityUnits = 'liter';
extracell = addcompartment(SubsystemModelObj,'extracell');
extracell.CapacityUnits = 'liter';

SubsystemModelObj.UserData = 'Transport';

%% A) Diffusion of intracellular input species through vesicle membrane and increase in output species concentration Ex_cell in extracellular space:
% 1) input -> output
% Reaction rates: kA = k0*(input - output)
Sobj_in = addspecies(ves,'input','InitialAmount',50);
Sobj_out = addspecies(extracell,'output','InitialAmount',0);
Pobj_k0 = addparameter(SubsystemModelObj,'k0',1);
Robj_1 = addreaction(SubsystemModelObj,'ves.input -> extracell.output','ReactionRate','k0 * (input - output)');
% Robj_1.ReactionRate


%% Simulation
%{
[t,simdata,names] = sbiosimulate(SubsystemModelObj);
%}
%% Plotting
%{
simdata_InputOutput = simdata(:,[1 2]);
figure
plot(t,simdata_InputOutput,'LineWidth',2);
% xlim([0 20])
xlabel('Time [s]');
ylabel('Species amounts [nM]');
title({'Time dependence of extracellular and intracellular concentration',' of species during simple diffusion'});
legend('input','output');
%}
end