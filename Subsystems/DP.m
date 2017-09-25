%% 15/08/2017 Miroslav Gasparek
%% SimBiology Double Phosphorylation signaling pathway model for subsystem framework in TX-TL

function SubsystemModelObj = DP
% clear, clc, close all

SubsystemModelObj = sbiomodel('DP');
% Set up the parameters for the simulation
csObj = getconfigset(SubsystemModelObj);
csObj.CompileOptions.DimensionalAnalysis = false;
csObj.SolverType = 'ode15s';
csObj.StopTime   = 20;      % Specified runtime to be 20s
csObj.RuntimeOptions.StatesToLog = 'all';

ves = addcompartment(SubsystemModelObj,'ves');
ves.CapacityUnits = 'liter';

SubsystemModelObj.UserData = 'Signaling';

%% Reactions
% 1) in + X <-> C1
% Reaction rates: k1f, k1r
Sobj_in = addspecies(ves,'in','InitialAmount',50);
Sobj_X = addspecies(ves,'X','InitialAmount',50);
Sobj_C1 = addspecies(ves,'C1','InitialAmount',0);
Pobj_k1f = addparameter(SubsystemModelObj,'k1f',1);
Pobj_k1r = addparameter(SubsystemModelObj,'k1r',1);
Robj_1 = addreaction(SubsystemModelObj,'in + X <-> C1','ReactionRate','k1f*in*X - k1r*C1');
% Robj_1.ReactionRate

% 2) C1 -> Xp + in
% Reaction rates: k2f
Sobj_Xp = addspecies(ves,'Xp','InitialAmount',0);
Pobj_k2f = addparameter(SubsystemModelObj,'k2f',1);
Robj_2 = addreaction(SubsystemModelObj,'C1 -> Xp + in','ReactionRate','k2f*C1');
% Robj_2.ReactionRate

% 3) E + Xp <-> C2
% Reaction rates: k3f, k3r
Sobj_E = addspecies(ves,'E','InitialAmount',50);
Sobj_C2 = addspecies(ves,'C2','InitialAmount',0);
Pobj_k3f = addparameter(SubsystemModelObj,'k3f');
Pobj_k3r = addparameter(SubsystemModelObj,'k3r');
Robj_3 = addreaction(SubsystemModelObj,'E + Xp <-> C2','ReactionRate','k3f*E*Xp - k3r*C2');
% Robj_3.ReactionRate

% 4) C2 -> X + E
% Reaction rates: k4f
Pobj_k4f = addparameter(SubsystemModelObj,'k4f',1);
Robj_4 = addreaction(SubsystemModelObj,'C2 -> X + E','ReactionRate','k4f*C2');
% Robj_4.ReactionRate

% 5) Xp + in <-> C3
% Reaction rates: k5f, k5r
Sobj_C3 = addspecies(ves,'C3','InitialAmount',0);
Pobj_k5f = addparameter(SubsystemModelObj,'k5f',1);
Pobj_k5r = addparameter(SubsystemModelObj,'k5r',1);
Robj_5 = addreaction(SubsystemModelObj,'Xp + in <-> C3','ReactionRate','k5f*Xp*in - k5r*C3');
% Robj_5.ReactionRate

% 6) C3 -> out + in
% Reaction rates: k6f
Sobj_out = addspecies(ves,'out','InitialAmount',0);
Pobj_k6f = addparameter(SubsystemModelObj,'k6f',1);
Robj_6 = addreaction(SubsystemModelObj,'C3 -> out + in','ReactionRate','k6f*C3');
% Robj_6.ReactionRate

% 7) E + out <-> C4
% Reaction rates: k7f, k7r
Sobj_C4 = addspecies(ves,'C4','InitialAmount',0);
Pobj_k7f = addparameter(SubsystemModelObj,'k7f',1);
Pobj_k7r = addparameter(SubsystemModelObj,'k7r',1);
Robj_7 = addreaction(SubsystemModelObj,'E + out <-> C4','ReactionRate','k7f*E*out - k7r*C4');
% Robj_7.ReactionRate

% 8) C4 -> Xp + E
% Reaction rates: k8f
Pobj_k8f = addparameter(SubsystemModelObj,'k8f',1);
Robj_8 = addreaction(SubsystemModelObj,'C4 -> Xp + E','ReactionRate','k8f*C4');
% Robj_8.ReactionRate

% SubsystemModelObj.species

%% Simulation
%{
[t,simdata,names] = sbiosimulate(SubsystemModelObj);
%}
%% Plotting
%{
simdata_InputOutput = simdata(:,[1 8]);
figure
plot(t,simdata_InputOutput,'LineWidth',2);
% xlim([0 20])
xlabel('Time [s]');
ylabel('Amount of Species');
title({'Temporal response of output to input signal','in isolated Double Phosphorylation system'});
legend('input','output');
%}
end