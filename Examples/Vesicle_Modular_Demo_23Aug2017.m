%% 20/09/2017 Miroslav Gasparek
%% Demo of the creation of artificial cell through modular framework 
%% Serving as a proof-of-concept for creation of modularization framework of TX-TL modeling toolbox
clc;clear;
% Create SimBiology model object vesicle
vesicle = BioSIMI_make_vesicle('vesicle')
% Create subsystem with reactions and species in DiffusionIn subsystem
DiffIn = BioSIMI_make_subsystem('DiffusionIn','input','output','DiffIn')
% Add reactions and species in DiffusionIn subystem to the appropriate
% compartments of vesicle object
BioSIMI_add_subsystem(vesicle,{'int','ext'},DiffIn)
% Create subsystem with reactions and species in Double-Phosphorylation subsystem
DP_Subsystem = BioSIMI_make_subsystem('DP','in','out','DP_Subsystem')
% Add reactions and species in Double-Phosphorylation subystem to the appropriate
% compartments of vesicle object
BioSIMI_add_subsystem(vesicle,'int',DP_Subsystem)
% Connect DiffusionIn subsystem with Double-Phosphorylation subsystem and
% create object of class subsystem that contains connection of both
% subsystems
DiffDP = BioSIMI_connect(vesicle,'int',DiffIn,DP_Subsystem,'DiffDP')
% Create subsystem with reactions and species in IFFL subsystem
IFFL_Subsystem = BioSIMI_make_subsystem('IFFL','in','out','IFFL_Subsystem')
% Add reactions and species in IFFL subystem to the appropriate
% compartments of vesicle object
BioSIMI_add_subsystem(vesicle,'int',IFFL_Subsystem)
%  Connect the combination of DiffusionIn and Double-Phoshporylation subsystem with IFFL
%  subsystem and create object of class subsystem that contains connection
%  of all three subsystems
Diff_DP_IFFL = BioSIMI_connect(vesicle,'int',DiffDP,IFFL_Subsystem,'Diff_DP_IFFL')
% Create subsystem with reactions and species in DiffusionOut subsystem
DiffOut = BioSIMI_make_subsystem('DiffusionOut','input','output','DiffOut')
% Add reactions and species in DiffusionOut subystem to the appropriate
% compartments of vesicle object
BioSIMI_add_subsystem(vesicle,{'int','ext'},DiffOut)
%  Connect the combination of DiffusionIn, Double-Phoshporylation, and IFFL
%  subsystem with Diffusion Out subsystem and create object of class subsystem 
% that contains connection of all four subsystems subsystems
FinalSystem = BioSIMI_connect(vesicle,'int',Diff_DP_IFFL,DiffOut,'FinalSystem')
% Run the simulation of the Final System
SimData = BioSIMI_runsim(FinalSystem,20)
% Plot the Input/Output relationship in the Final System
BioSIMI_plot(FinalSystem,SimData)