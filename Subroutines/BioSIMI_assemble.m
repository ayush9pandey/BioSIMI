%% 13/09/2017 Miroslav Gasparek
% Definition of the function that assembles final system creataed from interconnected
% Subsystems for simulation

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function final_subsystem = BioSIMI_assemble(varargin)
    if nargin == 1  % Default simulation time of 20s is used
        input_subsystem = varargin{1};
        input_subsystem = BioSIMI_rename_species_only(input_subsystem,input_subsystem.Name);
        txtl_runsim(input_subsystem.ModelObject);
        % Assemble final subsystem
        final_subsystem = subsystem;
        final_subsystem.ModelObject = input_subsystem.ModelObject;
        final_subsystem.Type = input_subsystem.Type;
        final_subsystem.Name = input_subsystem.Name;
        final_subsystem.Architecture = input_subsystem.Architecture;
        final_subsystem.Compartments = input_subsystem.Compartments;
        final_subsystem.Events = input_subsystem.ModelObject.Events;
        final_subsystem.Parameters = input_subsystem.ModelObject.Parameters;
        final_subsystem.Reactions = input_subsystem.ModelObject.Reactions;
        final_subsystem.Rules = input_subsystem.ModelObject.Rules;
        final_subsystem.Species = input_subsystem.ModelObject.Species;
        final_subsystem.Input = input_subsystem.Input;
        final_subsystem.Output = input_subsystem.Output;
        final_subsystem.SimSettings = input_subsystem.SimSettings;
        final_subsystem.Components = input_subsystem.Components;
    elseif nargin == 2 % Default simulation time of 20s is used
        input_subsystem = varargin{1};
        input_subsystem = BioSIMI_rename_species_only(input_subsystem,input_subsystem.Name);
        txtl_runsim(input_subsystem.ModelObject);
        % Assemble final subsystem
        final_subsystem = subsystem;
        final_subsystem.ModelObject = input_subsystem.ModelObject;
        final_subsystem.Type = input_subsystem.Type;
        final_subsystem.Name = varargin{2};
        final_subsystem.Architecture = input_subsystem.Architecture;
        final_subsystem.Compartments = input_subsystem.Compartments;
        final_subsystem.Events = input_subsystem.ModelObject.Events;
        final_subsystem.Parameters = input_subsystem.ModelObject.Parameters;
        final_subsystem.Reactions = input_subsystem.ModelObject.Reactions;
        final_subsystem.Rules = input_subsystem.ModelObject.Rules;
        final_subsystem.Species = input_subsystem.ModelObject.Species;        
        final_subsystem.Input = input_subsystem.Input;
        final_subsystem.Output = input_subsystem.Output;
        final_subsystem.SimSettings = input_subsystem.SimSettings;
        final_subsystem.Components = input_subsystem.Components;
    else
        error('Incorrect number of inputs');
    end
end