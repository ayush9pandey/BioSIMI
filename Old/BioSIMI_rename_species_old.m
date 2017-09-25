%% 07/09/2017 Miroslav Gasparek & Vipul Singhal

% Definition of the function that searches for common species in the species array of
% interconnection of two subsystems and amends them so that they have their initial names

% Serving as a prototype for creation of modularization framework of BioSIMI modeling toolbox

function final_system = BioSIMI_rename_species_old(input_subsystem)
    
    % Get component subsystems belonging to the final system
    % Define string of  a subsystems' name and an underscore to be removed
    for i = 1:size(input_subsystem.Components,2)
        subsystem_array(i) = input_subsystem.Components(i);
        string{i} = [subsystem_array(i).Name,'_'];
    end
    % Pre-allocate arrays for species' names
    for i = 1:size(input_subsystem.Components,2)
        str_array{i} = cell(1,size(input_subsystem.Species,1));
    end
    % Create array of names of the species
    for i = 1:size(input_subsystem.Components,2)
        for j = 1:size(input_subsystem.Species,1)
            if ~isempty(strfind(input_subsystem.Species(j).Name,string{i}))
                i
                j
                str_array{i}{j} = erase(input_subsystem.Species(j).Name,string{i});
            end
        end
    end
    % Delete empty entries in the cell of subsystem1 species' names
    for i = 1:size(input_subsystem.Components,2)
        emptyCells = cellfun('isempty',str_array{i});
        str_array{i}(emptyCells) = [];
    end
    % Merge the species arrays
    spec_array = cell(1,size(input_subsystem.Species,1));
    for i = 1:size(input_subsystem.Components,2)
        spec_array = [spec_array,str_array{i}];
    end
    % Delete empty entries in the cell of final syste species' names
    emptyCells = cellfun('isempty',spec_array);
    spec_array(emptyCells) = [];
    
    % Find positions of the species with the repeated name and delete repetitions
    [equal,index_equal,~] = unique(spec_array,'stable');
    subsystem_vector = 1:size(input_subsystem.Species,1);
    subsystem_vector = subsystem_vector';
    member = ismember(subsystem_vector,index_equal);
    [equal_species,~] = find(member == 0)
    for j= 1:(size(input_subsystem.Species,1) - size(r,1))
        j
        delete(input_subsystem.Species(r(j)))
    end
    
    final_system = subsystem;
    final_system.ModelObject = input_subsystem.ModelObject;
    final_system.Type = input_subsystem.Type;
    final_system.Name = input_subsystem.Name;                       % Assign Name to final Subsystem
    final_system.Architecture = input_subsystem.Architecture;
    final_system.Compartments = input_subsystem.Compartments;   % Assign Compartments to final Subsystem
    final_system.Events = input_subsystem.Events;               % Assign Events to final Subsystem
    final_system.Parameters = input_subsystem.Parameters;       % Assign Parameters to final Subsystem
    final_system.Reactions = input_subsystem.Reactions;         % Assign Reactions to final Subsystem
    final_system.Rules = input_subsystem.Rules;                 % Assign Rules to final Subsystem
    % final_system.Species = input_subsystem.Species;             % Assign Species to final Subsystem
    final_system.Input = input_subsystem.Input;
    final_system.Output = input_subsystem.Output;            % Assign Output to final Subsystem (Output of the subsystem_out)
    final_system.Components = input_subsystem.Components;

    % Get names and positions of the same species
%     for i = 1:size(final_subsystem.Components,2)
%         [result1,p1,p2] = intersect(str_array{i},str_array{i+1},'stable');
%         i = i+1;
%         if (i < size(final_subsystem.Components,2))
%             [equal_species,pos1,pos2] = intersect(result1,str_array{i+1},'stable');
%         else
%             equal_species = result1;
%             pos1 = p1;
%             pos2 = p2;
%             break
%         end
%     end
end
