%% 27/08/2017 Miroslav Gasparek
% Function that deletes names of redundant Species and Parameters from the subsystem

% Function creates final subsystem ready for simulation

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox
        
function final_system = BioSIMI_deleteUnused(final_subsystem,varargin)

    final_system = final_subsystem;
    
minArgs = 1;
maxArgs = 3;
narginchk(minArgs,maxArgs);

    if (nargin == 1)
    % Find and delete unused species and parameters
            rarray = findUnusedComponents(final_subsystem.ModelObject);
            for i = 1:size(rarray,1)
                rhandle = get(rarray(i));
                if (strcmp(rhandle.Type,'species') || strcmp(rhandle.Type,'parameters'))
                    delete(rarray(i));
                end
            end
    elseif (nargin == 2 && strcmp(varargin,'species'))
        % Find and delete unused species
            rarray = findUnusedComponents(final_subsystem.ModelObject);
            for i = 1:size(rarray,1)
                rhandle = get(rarray(i));
                if (strcmp(rhandle.Type,'species'))
                    delete(rarray(i));
                end
            end
     elseif (nargin == 2 && strcmp(varargin,'parameters'))
        % Find and delete unused parameters
            rarray = findUnusedComponents(final_subsystem.ModelObject);
            for i = 1:size(rarray,1)
                rhandle = get(rarray(i));
                if (strcmp(rhandle.Type,'parameters'))
                    delete(rarray(i));
                end
            end
            
     elseif ((nargin == 3 && strcmp(varargin(1),'parameters') && strcmp(varargin(2),'species')) || (nargin == 3 && strcmp(varargin(1),'species') && strcmp(varargin(2),'parameters')))
        % Find and delete unused species and parameters
            rarray = findUnusedComponents(final_subsystem.ModelObject);
            for i = 1:size(rarray,1)
                rhandle = get(rarray(i));
                if (strcmp(rhandle.Type,'species') || strcmp(rhandle.Type,'parameters'))
                    delete(rarray(i));
                end
            end
    end
    final_system.Species = final_subsystem.ModelObject.Species;
    final_system.Parameters = final_subsystem.ModelObject.Parameters;
    final_system.Species
    final_system.Parameters
end