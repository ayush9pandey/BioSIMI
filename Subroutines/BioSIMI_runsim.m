%% 13/09/2017 Miroslav Gasparek
% Definition of the function that simulates the interconnection of several subsystems 

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function SimData = BioSIMI_runsim(varargin)
    if nargin == 1  % Default simulation time of 20s is used
        final_system = varargin{1};
        if (strcmp(class(final_system),'SimBiology.Model'))
            SimData = sbiosimulate(final_system);
        elseif (strcmp(class(final_system),'subsystem'))
            SimData = sbiosimulate(final_system.ModelObject);
        end
    elseif nargin == 2  % User-specified simulation runtime (in seconds) is used
        final_system = varargin{1};
        simulation_time = varargin{2};
        if (strcmp(class(final_system),'SimBiology.Model'))
            csObj = getconfigset(final_system);
            csObj.StopTime = simulation_time;
            SimData = sbiosimulate(final_system);
        elseif (strcmp(class(final_system),'subsystem'))
            csObj = getconfigset(final_system.ModelObject);
            csObj.StopTime = simulation_time;
            SimData = sbiosimulate(final_system.ModelObject);
        end
    else
        error('Incorrect number of inputs');
    end
end