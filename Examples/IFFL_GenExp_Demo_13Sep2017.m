%% 13/09/2017 Miroslav Gasparek
%% Demo of interconnection of two TX-TL-created subsystems through BioSIMI modular framework 
%% Serves as a proof-of-concept for creation of modularization framework of TX-TL modeling toolbox
% Clear command window, clear workspace variables and close open figures
clc
clear
% close all
%% Create Incoherent Feed-Forward Loop (IFFL) circuit in TX-TL modeling toolbox
% Set up the standard TXTL tubes
% These load up the RNAP, Ribosome and degradation enzyme concentrations
tube1 = txtl_extract('E30VNPRL');
tube2 = txtl_buffer('E30VNPRL');
tube3 = txtl_newtube('circuit_closed_loop_withClpX');
% Define the DNA strands (defines TX-TL species + reactions)
txtl_add_dna(tube3, 'p70(50)', 'utr1(20)', 'AraC(600)',0.5*4.5, 'plasmid');
txtl_add_dna(tube3, 'pBAD(50)', 'utr1(20)', 'tetR(600)', 2*4.5, 'plasmid');
txtl_add_dna(tube3,'pBAD_ptet(150)', 'utr1(20)', 'deGFP(1000)-lva(20)',4*4.5, 'plasmid');
txtl_add_dna(tube3,'p70(50)', 'utr1(20)', 'ClpX(600)',0.1*4.5, 'plasmid');
% Add species to the tube 3
txtl_addspecies(tube3, 'arabinose', 10000);
txtl_addspecies(tube3, 'aTc', 1000);
ClpXToAdd = 80; % ClpX are added
% Mix the contents of the individual tubes
% Create Model Object 'IFFL' that can serve as model object for 'IFFL subsystem'
IFFL = txtl_combine([tube1, tube2, tube3]);

%% Create subsystem for 'IFFL' circuit assembled in TX-TL above
IFFL_Subsystem = BioSIMI_make_subsystem(IFFL,'arabinose','protein deGFP-lva*','IFFL_Subsystem');

%% Create simple Gene Expression (GenExp) circuit in TX-TL modeling toolbox
% Set up the standard TXTL tubes
% These load up the RNAP, Ribosome and degradation enzyme concentrations
tube1 = txtl_extract('E30VNPRL');
tube2 = txtl_buffer('E30VNPRL');
tube3 = txtl_newtube('gene_expression');
% Define the DNA strands (defines TX-TL species + reactions)
dna_deGFP = txtl_add_dna(tube3, ...
  'p70(50)', 'utr1(20)', 'deGFP(1000)', ...	% promoter, rbs, gene
   30, ...					% concentration (nM)
  'plasmid');					% type
% Mix the contents of the individual tubes
% Create Model Object 'GenExp' that can serve as model object for 'GenExp subsystem'
GenExp = txtl_combine([tube1, tube2, tube3]);

%% Create subsystem for 'GenExp' circuit assembled in TX-TL above
GenExp_Subsystem = BioSIMI_make_subsystem(GenExp,'RNAP','protein deGFP*','GenExp_Subsystem');

%% Create new subsystem 'FinalSystem' that contains species from connected 'IFFL' and 'GenExp' subsystems
FinalSystem = BioSIMI_connect_txtl('FinalSystem','int',IFFL_Subsystem,GenExp_Subsystem,'FinalSystem');
% Create new subsystem 'FS' that removes repeated species and the unused output of 'input subsystem'
% Set up events, parameters, and reactions in the final subsystem 'FS'
FS = BioSIMI_assemble(FinalSystem,'FS');
% Simulate final subsystem 'FS' with assembled reactions for (14*60*60) seconds
SimData = BioSIMI_runsim(FS,14*60*60);
% Plot time dependences of input (arabinose) and output (protein deGFP*) of interconnection of IFFL and GenExp subsystems
BioSIMI_plot(FS,SimData,'RNAP');
% Create standard TX-TL plots for interconnection of IFFL and GenExp subsystems
txtl_plot(SimData,FS.ModelObject);