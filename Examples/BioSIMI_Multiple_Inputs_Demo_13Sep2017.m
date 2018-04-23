%%% 13/09/2017 Miroslav Gasparek
%%% Demo of interconnection of multiple-input subsystems through BioSIMI modular framework 
%%% Serves as a proof-of-concept for creation of modularization framework of TX-TL modeling toolbox
% Clear command window, clear workspace variables and close open figures
% clc
% clear
close all
% Create SimBiology model object vesicle
vesicle = BioSIMI_make_vesicle('vesicle');
% Create subsystem with reactions, parameters and species in the first Double-Phosphorylation subsystem
DP_Subsystem1 = BioSIMI_make_subsystem('DP','in','out','DP_Subsystem1');
% Create subsystem with reactions, parameters and species in the second Double-Phosphorylation subsystem
DP_Subsystem2 = BioSIMI_make_subsystem('DP','in','out','DP_Subsystem2');
% Create subsystem with reactions, parameters and species in Incoherent Feed-Forward Loop subsystem
% Choose species activator protein A ('pA') and repressor protein B ('pB')
% as inputs of IFFL subsystem
IFFL_Subsystem = BioSIMI_make_subsystem('IFFL',{'pA','pB'},'out','IFFL_Subsystem');
% Add all subsystems into vesicle's internal compartment
BioSIMI_add_subsystem(vesicle,'int',DP_Subsystem1);
BioSIMI_add_subsystem(vesicle,'int',DP_Subsystem2);
BioSIMI_add_subsystem(vesicle,'int',IFFL_Subsystem);

% Create final system that consists of input subsystems and output
% subsystem
FinalSystem = BioSIMI_connect(vesicle,'int',{DP_Subsystem1,DP_Subsystem2},IFFL_Subsystem,'FinalSystem');
% Run the simulation of the Final System
SimData = BioSIMI_runsim(FinalSystem);
% Plot the Input/Output relationship in the Final System
BioSIMI_plot(FinalSystem,SimData);