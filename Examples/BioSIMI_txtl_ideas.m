%% Miroslav Gasparek 20/09/2017
% Serves as a simple example of desired function of BioSIMI with TX-TL
% modeling toolbox
%% THIS IS JUST ILLUSTRATIONAL AND DOES NOT RUN - FOR EXECUTABLE SYSTEM
%% CHECK 'IFFL_GenExp_Demo_13Sep2017'

% Add BioSIMI Soubroutines to the path and, if selected, add TX-TL
% subroutines to the path as well. 
% NOTE: TX-TL modeling toolbox has to be in the same folder
BioSIMI_init 
%%
% Use typical TX-TL procedure to set up the tubes and reactions 
% Setup tubes with extract and buffer
tube1 = txtl_extract('E30VNPRL');   % Creates model object1
tube2 = txtl_buffer('E30VNPRL');    % Creates model object2
tube3 = txtl_newtube('circuit_closed_loop_withClpX'); % Creates model object3
txtl_add_dna(tube3, 'p70(50)', 'rbs(20)', 'AraC(600)',0.5*4.5, 'plasmid'); % 0.5*4.5 Concentration in nM of DNA
txtl_add_dna(tube3, 'pBAD(50)', 'rbs(20)', 'tetR(600)', 2*4.5, 'plasmid');
txtl_add_dna(tube3,'pBAD_ptetIFFL(150)', 'rbs(20)', 'deGFP(1000)-lva(20)',4*4.5, 'plasmid');
txtl_add_dna(tube3,'p70(50)', 'rbs(20)', 'ClpX(600)',0.1*4.5, 'plasmid'); % Degradation tag for deGFP
txtl_addspecies(tube3, 'arabinose', 10000);
txtl_addspecies(tube3, 'aTc', 1000);
ClpXToAdd = 80;
% Combine the 3 model objects (i.e. all the species)
Mobj1 = txtl_combine([tube1, tube2, tube3]); 

%%
% Create Subsystem through BioSIMI and define certain species as input ('user_input'), and output ('user_output') and assign it name ('Subsystem1Name')
Subsystem1 = BioSIMI_make_subsystem(Mobj1,'user_input','user_output','Subsystem1Name'); % Now we have a representation of subsystem

%%
% Similarly, we can create another subsystem in TX-TL using different
% tubes:
tube1 = txtl_extract('E30VNPRL');   % Creates model object1
tube2 = txtl_buffer('E30VNPRL');    % Creates model object2
tube3 = txtl_newtube('circuit_closed_loop_withClpX'); % Creates model object3
txtl_add_dna(tube3, 'p70(50)', 'rbs(20)', 'AraC(600)',0.5*4.5, 'plasmid'); % 0.5*4.5 Concentration in nM of DNA
txtl_add_dna(tube3, 'pBAD(50)', 'rbs(20)', 'tetR(600)', 2*4.5, 'plasmid');
txtl_add_dna(tube3,'pBAD_ptetIFFL(150)', 'rbs(20)', 'deGFP(1000)-lva(20)',4*4.5, 'plasmid');
txtl_add_dna(tube3,'p70(50)', 'rbs(20)', 'ClpX(600)',0.1*4.5, 'plasmid'); % Degradation tag for deGFP
txtl_addspecies(tube3, 'arabinose', 10000);
txtl_addspecies(tube3, 'IPTG', 1000);
Mobj2 = txtl_combine([tube1, tube2, tube3]);

%%
% Create another subsystem 'Subsystem2' from model object Mobj2 created by TX-TL modeling toolbox
Subsystem2 = BioSIMI_make_subsystem(Mobj2,'user_input2','user_output2','Subsystem2Name');
% Create new subsystem named 'FinalSystem' that consists of Subsystem1 output connected to Subsystem2 input
% and create model object 'FinalSystem' (only if created by 
FinalSystem = BimSIMI_connect_species_only_new_object(FinalSystem,'compartment_name',Subsystem1,Subsystem2,'FinalSystem');
% Assemble the reactions, parameters and events required for running
% simulation of 'FinalSystem'
FinalSystem = BioSIMI_assemble(FinalSystem);
% Create model object 'vesicle' that represents a vesicle with empty internal and external compartments 
vesicle = BioSIMI_make_vesicle('vesicle');
% Add previously created 'FinalSystem' into 'int' comapartment of the model object vesicle
BioSIMI_add_subsystem(vesicle,'int',FinalSystem);
% Now we have a representation of subsystem in the vesicle

%%
% Setup reactions with knowledge of all the species
simData = BioSIMI_runsim(FinalSystem,simulationTime);

%%
txtl_plot(simData,FinalSystem) % Creates original TX-TL plots
BioSIMI_plot(FinalSystem,simData) % Creates BioSIMI input/output plots
