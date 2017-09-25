%% 11/08/2017 Miroslav Gasparek & Vipul Singhal & Richard Murray
%% SimBiology Desired outlook of the TX-TL modeling framework for Input/Output Model 
%% of vesicle containing double phosphorylation signaling pathway and Incoherent feed-forward loop 

%% Serving as a prototype for creation of modularization framework of TX-TL modeling toolbox

ves = txtl_create_vesicle('E9','B9');
txtl_add_subsystem(ves,'IFFL','inp1','out1');

txtl_add_subsystem(ves,'twocomp','var','inp1');

txtl_addsubystem(ves,'export_via_transporter','out1');
% txtl_connect_subsystems('twocomp','out1','IFFL','out1');

% txtl_connect_species(vesicle, 'int',IFFL_Subsystem,'pA',DP_Subsystem,'pA')
txtl_add_species(ves.ext,'var',1);

txtl_runsim
txtl_plot

% Desired plot should contain ves.ext.out1 vs. ves.int.out1

%% Suggestions from Vipul

% Class subsystem
       % properties: 
            % Model object (standard SimBiology model object, with
            % compartments, species, reactions, parameters, etc.)
            % input
            % output
% When you call IFFL = txtl_add_subsystem(ves,'IFFL',inp,out)
% ... creates subsystem class object twocomp.mobj, twocomp.inp., 
% twocomp.out = 