%% 07/09/2017 Miroslav Gasparek & Vipul Singhal
%% Definition of the function that searches for common species in the species array of
%% interconnection of two subsystems and amends them so that they have their initial names
%% Serving as a prototype for creation of modularization framework of TX-TL modeling toolbox
% Currently throuws out error if the single subsystem is passed into it
function final_system = BioSIMI_rename_species_only(input_subsystem,final_system_name)
    
    % Get component subsystems belonging to the final system
    
    if isempty(input_subsystem.Components)
        i = 1;
        % Define string of  a subsystems' name and an underscore to be removed
        string{i} = [input_subsystem.Name,'_'];
        % Pre-allocate arrays for species' names
        str_array{i} = cell(1,size(input_subsystem.Species,1));
        % Create array of names of the species
        for j = 1:size(input_subsystem.Species,1)
            if ~isempty(strfind(input_subsystem.Species(j).Name,string{i}))
                str_array{i}{j} = erase(input_subsystem.Species(j).Name,string);
            end
        end
        % Delete empty entries in the cell of subsystem1 species' names
        emptyCells = cellfun('isempty',str_array{i});
        str_array{i}(emptyCells) = [];
        % Create the final array of species
        spec_array = str_array{i};
        remove_array = cell2mat(spec_array);
    else
        % Define string of  a subsystems' name and an underscore to be removed
        if ~iscell(input_subsystem.Components)
            for i = 1:size(input_subsystem.Components,2)
                string{i} = [input_subsystem.Components(i).Name,'_'];
            end
        else
            for i = 1:size(input_subsystem.Components,2)
                string{i} = [input_subsystem.Components{i}.Name,'_'];
            end
        end
        % Pre-allocate arrays for species' names
        for i = 1:size(input_subsystem.Components,2)
            str_array{i} = cell(1,size(input_subsystem.Species,1));
        end
        % Create array of names of the species
        for i = 1:size(input_subsystem.Components,2)
            for j = 1:size(input_subsystem.Species,1)
                if ~isempty(strfind(input_subsystem.Species(j).Name,string{i}))
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
        % Delete empty entries in the cell of final system species' names
        emptyCells = cellfun('isempty',spec_array);
        spec_array(emptyCells) = [];
        % Find positions of the reduntant 'output' species of 'input'
        % subsystems
        out_array = [];
        if iscell(input_subsystem.Components)
            for i = 1:size(input_subsystem.Components,2)
                for j = 1:size(input_subsystem.Species,1)
                    if (strcmp(input_subsystem.Components{i}.Output.Name,input_subsystem.Species(j).Name) && ~strcmp(input_subsystem.Components{i}.Output.Name,input_subsystem.Output.Name))
                        out_array(i) = j;
                    end
                end
            end
        else
            for i = 1:size(input_subsystem.Components,2)
                for j = 1:size(input_subsystem.Species,1)
                    if (strcmp(input_subsystem.Components(i).Output.Name,input_subsystem.Species(j).Name) && ~strcmp(input_subsystem.Components(i).Output.Name,input_subsystem.Output.Name))
                        out_array(i) = j;
                    end
                end
            end
        end
        % Find positions of the species with the repeated name
        [equal,index_equal,~] = unique(spec_array,'stable');
        subsystem_vector = 1:size(input_subsystem.Species,1);
        subsystem_vector = subsystem_vector';
        member = ismember(subsystem_vector,index_equal);
        [equal_array,~] = find(member == 0);
        % Create final vector of positions of species that are to be
        % removed from the final subsystem
        remove_array = unique([out_array';equal_array]);
    end
        
%% Create final system

    % Create final subsystem
    final_system = subsystem;
    % Create SimBiology Model object of the final subsystem
    final_system.ModelObject = sbiomodel(final_system_name);
    % Add empty compartments to the final subsystem
    for i = 1:size(input_subsystem.ModelObject.Compartments,1)
        comp(i) = addcompartment(final_system.ModelObject,['comp',num2str(i)]);
    end
    % Rename compartments so that the names are same as in original input
    % subsystem
    for i = 1:size(input_subsystem.Compartments,1)
        rename(final_system.ModelObject.Compartments(i),input_subsystem.Compartments(i).Name);
    end
    final_system.Compartments = final_system.ModelObject.Compartments;
    final_system.Type = input_subsystem.Type;
    final_system.Name = input_subsystem.Name;                       % Assign Name to final Subsystem
    final_system.Architecture = input_subsystem.Architecture;
    % final_system.Events = input_subsystem.Events;               % Assign Events to final Subsystem
    % final_system.Parameters = input_subsystem.Parameters;       % Assign Parameters to final Subsystem
    % final_system.Reactions = input_subsystem.Reactions;         % Assign Reactions to final Subsystem
    % final_system.Rules = input_subsystem.Rules;                 % Assign Rules to final Subsystem
    final_system.Components = input_subsystem.Components;
    
    % Copy uniquely named species  from input subsystem to the final system
    for i = 1:size(input_subsystem.Species,1)
        specs_handle = get(input_subsystem.Species(i));
        for j = 1:size(final_system.ModelObject.Compartments,1)
            if (strcmp(final_system.ModelObject.Compartments(j).Name,specs_handle.Parent.Name) && ~ismember(i,remove_array))
                specs(i) = copyobj(input_subsystem.Species(i),final_system.ModelObject.Compartments(j));
            end
        end
    end
    % Rename species so subsystem name prefixes are removed
    for j = 1:size(final_system.ModelObject.Species,1)
        for i = 1:size(string,2)
            if ~isempty(strfind(final_system.ModelObject.Species(j).Name,string{i}))
                rename(final_system.ModelObject.Species(j),erase(final_system.ModelObject.Species(j).Name,string{i}));
            end
        end
    end
    % Add renamed species to the final subsystem
    final_system.Species = final_system.ModelObject.Species;
    % Add input of initial subsystem to created final subsystem and rename
    % it to remove its parent components subsystem's name
    final_system.Input = input_subsystem.Input;
    if iscell(input_subsystem.Input)
        for j = 1:size(final_system.Input,2)
            for i = 1:size(string,2)
                if ~isempty(strfind(final_system.Input{j}.Name,string{i}))
                    rename(final_system.Input{j},erase(final_system.Input{j}.Name,string{i}));
                end
            end
        end
    else
        for j = 1:size(final_system.Input,2)
            for i = 1:size(string,2)
                if ~isempty(strfind(final_system.Input(j).Name,string{i}))
                    rename(final_system.Input(j),erase(final_system.Input(j).Name,string{i}));
                end
            end
        end
    end
    % Add output of initial subsystem to created final subsystem and rename
    % it to remove its parent components subsystem's name   
    final_system.Output = input_subsystem.Output;
    for j = 1:size(final_system.Output,2)
        for i = 1:size(string,2)
            if ~isempty(strfind(final_system.Output(j).Name,string{i}))
                rename(final_system.Output(j),erase(final_system.Output(j).Name,string{i}));
            end
        end
    end
    %% TODO: Improve the code so that it accepts models with multiple compartments
    % Remove compartment if it is not being used
    for i = 1:size(final_system.ModelObject.Compartments,1)
        comp_handle = findUsages(final_system.ModelObject.Compartments(i));
        if isempty(comp_handle)
            delete(final_system.ModelObject.Compartments(i))
        end
    end
    final_system.Compartments = final_system.ModelObject.Compartments;
   
    % Copy User Data required for simulation in TX-TL from input subsystem
    % to the final system
    final_system.ModelObject.UserData = input_subsystem.ModelObject.UserData;
end