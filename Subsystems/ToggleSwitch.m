%% 15/08/2017 Miroslav Gasparek
%% SimBiology Genetic toggle switch model for subsystem framework in TX-TL

function SubsystemModelObj = ToggleSwitch
% clear, clc, close all
SubsystemModelObj = sbiomodel('ToggleSwitch');
% Set up the parameters for the simulation
csObj = getconfigset(SubsystemModelObj);
csObj.CompileOptions.DimensionalAnalysis = false;
csObj.SolverType = 'ode15s';
csObj.StopTime   = 20;      % Specified runtime to be 20s
csObj.RuntimeOptions.StatesToLog = 'all';


ves = addcompartment(SubsystemModelObj,'ves');
ves.CapacityUnits = 'liter';

SubsystemModelObj.UserData = 'Regulatory';

%% Reactions %%
%% A) Production of protein 'A' and its decay
% A1) pA + RNAP <-> S1
% Reaction rates: kA1f, kA1r
Sobj_pA = addspecies(ves,'pA','InitialAmount',50); % pA is promoter binding site of protein 'A'
Sobj_RNAP = addspecies(ves,'RNAP','InitialAmount',50);
Sobj_S1 = addspecies(ves,'S1','InitialAmount',0);
Pobj_kA1f = addparameter(SubsystemModelObj,'kA1f',1);
Pobj_kA1r = addparameter(SubsystemModelObj,'kA1r',1);
Robj_A1 = addreaction(SubsystemModelObj,'pA + RNAP <-> S1','ReactionRate','kA1f*pA*RNAP - kA1r*S1');
% Robj_A1.ReactionRate

% A2) S1 -> S1 + A
% Reaction rates: kA2f
Sobj_A = addspecies(ves,'A','InitialAmount',0);
Pobj_kA2f = addparameter(SubsystemModelObj,'kA2f',1);
Robj_A2 = addreaction(SubsystemModelObj,'S1 -> S1 + A','ReactionRate','kA2f*S1');
% Robj_A2.ReactionRate

% A3) A -> null
% Reaction rates: kA3f
Pobj_kA3f = addparameter(SubsystemModelObj,'kA3f',1);
Robj_A3 = addreaction(SubsystemModelObj,'A -> null','ReactionRate','kA3f*A');
% Robj_A3.ReactionRate
%% B) Production of protein 'B' and output species 'out' and their decay
% B1) pB + RNAP <-> S2
% Reaction rates: k6f, k6r
Sobj_pB = addspecies(ves,'pB','InitialAmount',50);
Sobj_S2 = addspecies(ves,'S2','InitialAmount',0);
Pobj_kB1f = addparameter(SubsystemModelObj,'kB1f',1,'ValueUnits','1/(molecule*second)');
Pobj_kB1r = addparameter(SubsystemModelObj,'kB1r',1,'ValueUnits','1/(second)');
Robj_B1 = addreaction(SubsystemModelObj,'pB + RNAP <-> S2','ReactionRate','kB1f*pB*RNAP - kB1r*S2');
% Robj_B1.ReactionRate

% B2) S2 -> S2 + B + out
% Reaction rates: kB2f
Sobj_B = addspecies(ves,'B','InitialAmount',0);
Sobj_out = addspecies(ves,'out','InitialAmount',0);
Pobj_kB2f = addparameter(SubsystemModelObj,'kB2f',1,'ValueUnits','1/(second)');
Robj_B2 = addreaction(SubsystemModelObj,'S2 -> S2 + B + out','ReactionRate','kB2f*S2');
% Robj_B2.ReactionRate

% B3) B -> null
% Reaction rates: kB3f
Pobj_kB3f = addparameter(SubsystemModelObj,'kB3f',1);
Robj_B3 = addreaction(SubsystemModelObj,'B -> null','ReactionRate','kB3f*B');
% Robj_B3.ReactionRate

% B4) out -> null
% Reaction rates: kB4f
Pobj_kB4f = addparameter(SubsystemModelObj,'kB4f',1);
Robj_B4 = addreaction(SubsystemModelObj,'out -> null','ReactionRate','kB4f*out');
% Robj_B4.ReactionRate
%% C) Sequestration of repressing protein 'A' by input2 and protein 'B' by input1
% C1) A + in1 <-> C1 (sequesters)
% Reaction rates: kC1f, kC1r
Sobj_in1 = addspecies(ves,'in1','InitialAmount',0);
Sobj_C1 = addspecies(ves,'C1','InitialAmount',0);
Pobj_kC1f = addparameter(SubsystemModelObj,'kC1f',1,'ValueUnits','1/(molecule*second)');
Pobj_kC1r = addparameter(SubsystemModelObj,'kC1r',1,'ValueUnits','1/(second)');
Robj_C1 = addreaction(SubsystemModelObj,'A + in1 <-> C1','ReactionRate','kC1f*A*in1 - kC1r*C1');
% Robj_C1.ReactionRate

% C2) B + in2 <-> C2 (sequesters)
% Reaction rates: kC2f, kC2r
Sobj_in2 = addspecies(ves,'in2','InitialAmount',0);
Sobj_C2 = addspecies(ves,'C2','InitialAmount',0);
Pobj_kC2f = addparameter(SubsystemModelObj,'kC2f',1);
Pobj_kC2r = addparameter(SubsystemModelObj,'kC2r',1);
Robj_C2 = addreaction(SubsystemModelObj,'B + in2 <-> C2','ReactionRate','kC2f*B*in2 - kC2r*C2');
% Robj_C2.ReactionRate
%% D) Sequestration of promoter sites by polymerized protein 'A' and protein 'B'
% Generally, we assume formation of complex An of protein 'A' from n
% molecules of protein A
% D1) A + A + ... + A -> An
% Reaction rates: kD1_Vm/( (kD1_K/A)^n + 1 )
% Hill kinetics is used
n = 2; % n = Cooperativity/Hill function coefficient
Sobj_An = addspecies(ves,'An','InitialAmount',0);
Pobj_kD1_Vm = addparameter(SubsystemModelObj,'kD1_Vm',1);
Pobj_kD1_K = addparameter(SubsystemModelObj,'kD1_K',1);
Pobj_n = addparameter(SubsystemModelObj,'n',n);
Robj_D1 = addreaction(SubsystemModelObj,'A -> An','ReactionRate','kD1_Vm/( (kD1_K/A)^n + 1 )');
% Robj_D1.ReactionRate

% D2) An + pB <-> S3
% Reaction rates: kD2f, kD2r
Sobj_S3 = addspecies(ves,'S3','InitialAmount',0);
Pobj_kD2f = addparameter(SubsystemModelObj,'kD2f',1);
Pobj_kD2r = addparameter(SubsystemModelObj,'kD2r',1);
Robj_D2 = addreaction(SubsystemModelObj,'An + pB <-> S3','ReactionRate','kD2f*An*pB - kD2r*S3');
% Robj_D2.ReactionRate

% Generally, we assume formation of complex Bm of protein 'B' from m
% molecules of protein B
% D1) B + B + ... + B -> Bm
% Reaction rates: kD3_Vm/( (kD3_K/B)^m + 1 )
% Hill kinetics is used
m = 2; % m = Cooperativity/Hill function coefficient
Sobj_Bm = addspecies(ves,'Bm','InitialAmount',0);
Pobj_kD3_Vm = addparameter(SubsystemModelObj,'kD3_Vm',1);
Pobj_kD3_K = addparameter(SubsystemModelObj,'kD3_K',1);
Pobj_m = addparameter(SubsystemModelObj,'m',m);
Robj_D3 = addreaction(SubsystemModelObj,'B -> Bm','ReactionRate','kD3_Vm/( (kD3_K/B)^m + 1 )');
% Robj_D3.ReactionRate

% D4) Bm + pA <-> S4
% Reaction rates: kD4f, kD4r
Sobj_S4 = addspecies(ves,'S4','InitialAmount',0);
Pobj_kD4f = addparameter(SubsystemModelObj,'kD4f',1);
Pobj_kD4r = addparameter(SubsystemModelObj,'kD4r',1);
Robj_D4 = addreaction(SubsystemModelObj,'Bm + pA <-> S4','ReactionRate','kD4f*Bm*pA - kD4r*S4');
% Robj_D4.ReactionRate

%% Add switching events
e1 = addevent(SubsystemModelObj,'time>=2','in1 = 50');
e2 = addevent(SubsystemModelObj,'time>=10','in2 = 50');
%% Simulation
%%{
SimData = sbiosimulate(SubsystemModelObj);
%}
%% Plotting
%%{
data = get(SimData);
    for i = 1:size(data.DataInfo)
        if(strcmp('in1',data.DataInfo{i}.Name))
            Input1Data = data.Data(:,i);
        end
    end
    for i = 1:size(data.DataInfo)
        if(strcmp('in2',data.DataInfo{i}.Name))
            Input2Data = data.Data(:,i);
        end
    end
    for i = 1:size(data.DataInfo)
        if(strcmp('out',data.DataInfo{i}.Name))
            OutputData = data.Data(:,i);
        end
    end
figure
plot(data.Time,[Input1Data Input2Data OutputData],'LineWidth',2)
xlabel('Time [s]');
ylabel('Amount of Species');
title({'Time response of output in genetic toggle switch',' to varying amounts of inducers'});
legend('input1','input2','output');

%}
end