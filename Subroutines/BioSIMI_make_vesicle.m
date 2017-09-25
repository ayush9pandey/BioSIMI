%% 13/08/2017 Miroslav Gasparek
% Function to create the SimBiology model object 'vesicle' with two compartments:
% int: intracellular compartment
% ext: extracellular compartment

% Function that has to be initialized as the first for analysis of
% interconnection of subsystems in BioSIMI modeling toolbox

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function target_obj = BioSIMI_make_vesicle(name)
target_obj = sbiomodel(name);
Cobj_int = addcompartment(target_obj,'int');
% Cobj_int.CapacityUnits = 'liter';
Cobj_ext = addcompartment(target_obj,'ext');
% Cobj_ext.CapacityUnits = 'liter';
end