%% 15/08/2017 Miroslav Gasparek
%% SimBiology Incoherent Feedforward loop model for subsystem framework in TX-TL

function SubsystemModelObj = IFFL
% clear, clc, close all
SubsystemModelObj = sbiomodel('IFFL');
% Set up the parameters for the simulation
csObj = getconfigset(SubsystemModelObj);
csObj.CompileOptions.DimensionalAnalysis = false;
csObj.SolverType = 'ode15s';
csObj.StopTime   = 20;      % Specified runtime to be 20s
csObj.RuntimeOptions.StatesToLog = 'all';

ves = addcompartment(SubsystemModelObj,'ves');
ves.CapacityUnits = 'liter';

SubsystemModelObj.UserData = 'Regulatory';

%% Reactions
% 1) in + DA <-> C1
% Reaction rates: k1f, k1r
Sobj_in = addspecies(ves,'in','InitialAmount',50);
Sobj_DA = addspecies(ves,'DA','InitialAmount',50);
Sobj_C1 = addspecies(ves,'C1','InitialAmount',0);
Pobj_k1f = addparameter(SubsystemModelObj,'k1f',1);
Pobj_k1r = addparameter(SubsystemModelObj,'k1r',1);
Robj_1 = addreaction(SubsystemModelObj,'in + DA <-> C1','ReactionRate','k1f*in*DA - k1r*C1');
% Robj_1.ReactionRate

% 2) C1 -> C1 + mA
% Reaction rates: k2f
Sobj_mA = addspecies(ves,'mA','InitialAmount',0);
Pobj_k2f = addparameter(SubsystemModelObj,'k2f',1);
Robj_2 = addreaction(SubsystemModelObj,'ves.C1 -> ves.C1 + ves.mA','ReactionRate','k2f*C1');
% Robj_2.ReactionRate
% 3) mA -> mA + pA
% Reaction rates: k3f
Sobj_pA = addspecies(ves,'pA','InitialAmount',0);
Pobj_k3f = addparameter(SubsystemModelObj,'k3f',1);
Robj_3 = addreaction(SubsystemModelObj,'mA -> mA + pA','ReactionRate','k3f*mA');
% Robj_3.ReactionRate
% 4) mA -> null
% Reaction rates: k4f
Pobj_k4f = addparameter(SubsystemModelObj,'k4f',1);
Robj_4 = addreaction(SubsystemModelObj,'mA -> null','ReactionRate','k4f*mA');
% Robj_4.ReactionRate
% 5) pA -> null
% Reaction rates: k5f
Pobj_kCf = addparameter(SubsystemModelObj,'k5f',1);
Robj_5 = addreaction(SubsystemModelObj,'pA -> null','ReactionRate','k5f*pA');
% Robj_5.ReactionRate
% 6) pA + DB <-> C2
% Reaction rates: k6f, k6r
Sobj_DB = addspecies(ves,'DB','InitialAmount',50);
Sobj_C2 = addspecies(ves,'C2','InitialAmount',0);
Pobj_k6f = addparameter(SubsystemModelObj,'k6f');
Pobj_k6r = addparameter(SubsystemModelObj,'k6r');
Robj_6 = addreaction(SubsystemModelObj,'pA + DB <-> C2','ReactionRate','k6f*pA*DB - k6r*C2');
% Robj_6.ReactionRate
% 7) C2 -> C2 + mB
% Reaction rates: k7f
Sobj_mB = addspecies(ves,'mB','InitialAmount',0);
Pobj_k7f = addparameter(SubsystemModelObj,'k7f',1);
Robj_7 = addreaction(SubsystemModelObj,'C2 -> C2 + mB','ReactionRate','k7f*C2');
% Robj_7.ReactionRate
% 8) mB -> mB + pB
% Reaction rates: k8f
Sobj_pB = addspecies(ves,'pB','InitialAmount',0);
Pobj_k8f = addparameter(SubsystemModelObj,'k8f',1);
Robj_8 = addreaction(SubsystemModelObj,'mB -> mB + pB','ReactionRate','k8f*mB');
% Robj_8.ReactionRate
% 9) mB -> null
% Reaction rates: k9f
Pobj_k9f = addparameter(SubsystemModelObj,'k9f',1);
Robj_9 = addreaction(SubsystemModelObj,'mB -> null','ReactionRate','k9f*mB');
% Robj_9.ReactionRate
% 10) pB -> null
% Reaction rates: k10f
Pobj_k10f = addparameter(SubsystemModelObj,'k10f');
Robj_10 = addreaction(SubsystemModelObj,'pB -> null','ReactionRate','k10f*pB');
% Robj_10.ReactionRate
% 11) pB + DC <-> C3 (sequesters)
% Reaction rates: k11f, k11r
Sobj_DC = addspecies(ves,'DC','InitialAmount',50);
Sobj_C3 = addspecies(ves,'C3','InitialAmount',0);
Pobj_k11f = addparameter(SubsystemModelObj,'k11f');
Pobj_k11r = addparameter(SubsystemModelObj,'k11r');
Robj_11 = addreaction(SubsystemModelObj,'pB + DC <-> C3','ReactionRate','k11f*pB*DC - k11r*C3');
% Robj_11.ReactionRate
% 12) pA + DC <-> C4 (can be further used)
% Reaction rates: k12f, k12r
Sobj_C4 = addspecies(ves,'C4','InitialAmount',0);
Pobj_k12f = addparameter(SubsystemModelObj,'k12f');
Pobj_k12r = addparameter(SubsystemModelObj,'k12r');
Robj_12 = addreaction(SubsystemModelObj,'pA + DC <-> C4','ReactionRate','k12f*pA*DC - k12r*C4');
% Robj_12.ReactionRate
% 13) C3 + pA <-> C5 (sequesters)
% Reaction rates: k13f, k13r
Sobj_C5 = addspecies(ves,'C5','InitialAmount',0);
Pobj_k13f = addparameter(SubsystemModelObj,'k13f');
Pobj_k13r = addparameter(SubsystemModelObj,'k13r');
Robj_13 = addreaction(SubsystemModelObj,'C3 + pA <-> C5','ReactionRate','k13f*C3*pA - k13r*C5');
% Robj_13.ReactionRate
% 14) C4 + pB <-> C6 (sequesters)
% Reaction rates: k14f, k14r
Sobj_C6 = addspecies(ves,'C6','InitialAmount',0);
Pobj_k14f = addparameter(SubsystemModelObj,'k14f',1);
Pobj_k14r = addparameter(SubsystemModelObj,'k14r',1);
Robj_14 = addreaction(SubsystemModelObj,'C4 + pB <-> C6','ReactionRate','k14f*C4*pB - k14r*C6');
% Robj_14.ReactionRate
% 15) C4 -> C4 + mC
% Reaction rates: k15f
Sobj_mC = addspecies(ves,'mC','InitialAmount',0);
Pobj_k15f = addparameter(SubsystemModelObj,'k15f');
Robj_15 = addreaction(SubsystemModelObj,'C4 -> C4 + mC','ReactionRate','k15f*C4');
% Robj_15.ReactionRate
% 16) mC -> mC + out
% Reaction rates: k16f
Sobj_Output = addspecies(ves,'out','InitialAmount',0);
Pobj_k16f = addparameter(SubsystemModelObj,'k16f');
Robj_16 = addreaction(SubsystemModelObj,'mC -> mC + out','ReactionRate','k16f*mC');
% Robj_16.ReactionRate
% 17) mC -> null
% Reaction rates: k17f
Pobj_k17f = addparameter(SubsystemModelObj,'k17f');
Robj_17 = addreaction(SubsystemModelObj,'mC -> null','ReactionRate','k17f*mC');
% Robj_17.ReactionRate
% 18) out -> null
% Reaction rates: k18f
Pobj_k18f = addparameter(SubsystemModelObj,'k18f');
Robj_18 = addreaction(SubsystemModelObj,'out -> null','ReactionRate','k18f*out');
% Robj_18.ReactionRate

%% Simulation
%%%{
[t,simdata,names] = sbiosimulate(SubsystemModelObj);
%%%}
%% Plotting
%%{
simdata_InputOutput = simdata(:,[1 16]);
figure
plot(t,simdata_InputOutput,'LineWidth',2);
xlim([0 20])
xlabel('Time [s]');
ylabel('Species amounts [nM]');
title({'Temporal response of output p_C to "in" signal','in isolated IFFL system'});
legend('input','output p_{C}');
%%}
end