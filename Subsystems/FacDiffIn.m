%% 27/08/2017 Miroslav Gasparek
%% SimBiology Model of membrane import through channel-facilitated diffusion

function SubsystemModelObj = FacDiffIn
% clear, clc, close all
SubsystemModelObj = sbiomodel('FacDiffIn');
% Set up the parameters for the simulation
csObj = getconfigset(SubsystemModelObj);
csObj.SolverType = 'ode15s';
csObj.StopTime   = 20;      % Specified runtime to be 20s
csObj.RuntimeOptions.StatesToLog = 'all';

ves = addcompartment(SubsystemModelObj,'ves');
ves.CapacityUnits = 'liter';
extracell = addcompartment(SubsystemModelObj,'extracell');
extracell.CapacityUnits = 'liter';

SubsystemModelObj.UserData = 'Transport';

%%{
%% Model created by reactions in Michaelis-Menten's kinetics model 
%% Assuming steady-state concentration of Transporter protein - Substrate complex
% Reactions:
% 1) extracell.input -> ves.output
% Reaction rates: k = (k0*TranP*(input-output))/(k1*TranP+abs(input-output))
Sobj_input = addspecies(extracell,'input','InitialAmount',50);
Sobj_output = addspecies(ves,'output','InitialAmount',0);
Sobj_TranP = addspecies(ves,'TranP','InitialAmount',10);

Pobj_k0 = addparameter(SubsystemModelObj,'k0',1);
Pobj_k1 = addparameter(SubsystemModelObj,'k1',10);

Robj_1 = addreaction(SubsystemModelObj,'extracell.input -> ves.output','ReactionRate','(k0*TranP*(input-output))/(k1*TranP+abs(input-output))');
Robj_1.ReactionRate
%}

%% Simulation
%%{
% [t,simdata,names] = sbiosimulate(SubsystemModelObj);
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
title({'Time dependence of extracellular and intracellular amount',' of species during facilitated diffusion'});
legend('input','output');
%}
end