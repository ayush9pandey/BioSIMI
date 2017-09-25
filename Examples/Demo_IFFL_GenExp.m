%% IFFL TRIAL
% IFFL as tested in lab by S. Guo
% VS 2013

%% clean up


close all

%% no clpX
% Set up the standard TXTL tubes


tube1 = txtl_extract('E30VNPRL');
tube2 = txtl_buffer('E30VNPRL');

tube3 = txtl_newtube('circuit_closed_loop_withClpX');

txtl_add_dna(tube3, 'p70(50)', 'utr1(20)', 'AraC(600)',0.5*4.5, 'plasmid');
txtl_add_dna(tube3, 'pBAD(50)', 'utr1(20)', 'tetR(600)', 2*4.5, 'plasmid');
txtl_add_dna(tube3,'pBAD_ptet(150)', 'utr1(20)', 'deGFP(1000)-lva(20)',4*4.5, 'plasmid');
txtl_add_dna(tube3,'p70(50)', 'utr1(20)', 'ClpX(600)',0.1*4.5, 'plasmid');

txtl_addspecies(tube3, 'arabinose', 10000);
txtl_addspecies(tube3, 'aTc', 1000);
ClpXToAdd = 80;
% set up well_a1
IFFL = txtl_combine([tube1, tube2, tube3]);

%% GeneExpression TRIAL
% geneexpr.m - basic gene expression reaction
% R. M. Murray, 9 Sep 2012
%
% This file contains a simple example of setting up a TXTL simulation
% for gene expression using the standard TXTL control plasmid.
%

% Set up the standard TXTL tubes
% These load up the RNAP, Ribosome and degradation enzyme concentrations
tube1 = txtl_extract('E30VNPRL');
tube2 = txtl_buffer('E30VNPRL');

% Now set up a tube that will contain our DNA
tube3 = txtl_newtube('gene_expression');

% Define the DNA strands (defines TX-TL species + reactions)
dna_deGFP = txtl_add_dna(tube3, ...
  'p70(50)', 'utr1(20)', 'deGFP(1000)', ...	% promoter, rbs, gene
   30, ...					% concentration (nM)
  'plasmid');					% type

% Mix the contents of the individual tubes
GenExp = txtl_combine([tube1, tube2, tube3]);
