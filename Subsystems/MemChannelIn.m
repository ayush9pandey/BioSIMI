%% 22/08/2017 Miroslav Gasparek
%% SimBiology Model of membrane import through conformational changes in membrane channel
%% Imported species binds to channel and is imported according to the enzyme kinetics

function SubsystemModelObj = MemChannelIn
% clear, clc, close all
SubsystemModelObj = sbiomodel('MemChannelIn');
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

%%{
%% Model created by reactions in Michaelis-Menten's kinetics model:
% extracell.input + ves.ChannelP <-> ves.C1
% Reaction rates: k1f, k1r
% ves.C1 -> ves.ChannelP + ves.output
% Reaction rates: k2f
Sobj_input = addspecies(extracell,'input','InitialAmount',50);
Sobj_ChannelP = addspecies(ves,'ChannelP','InitialAmount',40);
Sobj_C1 = addspecies(ves,'C1','InitialAmount',0);
Sobj_output = addspecies(ves,'output','InitialAmount',0);

Pobj_k1f = addparameter(SubsystemModelObj,'k1f',10);
Pobj_k1r = addparameter(SubsystemModelObj,'k1r',10);
Pobj_k2f = addparameter(SubsystemModelObj,'k2f',0.1);

Robj_1 = addreaction(SubsystemModelObj,'extracell.input + ves.ChannelP <-> ves.C1','ReactionRate','k1f*ChannelP*input - k1r*C1');
Robj_2 = addreaction(SubsystemModelObj,'ves.C1 -> ves.ChannelP + ves.output','ReactionRate','k2f*C1');

% Robj_1.ReactionRate
% Robj_2.ReactionRate
%}

%% Simulation
%%{
SimData = sbiosimulate(SubsystemModelObj);
%}
%% Plotting
%%{
data = get(SimData);
    for i = 1:size(data.DataInfo)
        if(strcmp('input',data.DataInfo{i}.Name))
            InputData = data.Data(:,i);
        end
    end
    for i = 1:size(data.DataInfo)
        if(strcmp('output',data.DataInfo{i}.Name))
            OutputData = data.Data(:,i);
        end
    end
figure
plot(data.Time,[InputData OutputData],'LineWidth',2)
xlabel('Time [s]');
ylabel('Species amount [nM]');
title({'Time dependence of extracellular and intracellular amount',' of species during channel-mediated import'});
legend('input','output');
%}
end