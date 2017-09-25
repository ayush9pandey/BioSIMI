%% 22/09/2017 Miroslav Gasparek

% Definition of a function that adds SimBiology objects contained within
% specific object of class 'subsystem' that has been created by 'BioSIMI_make_subsystem'
% into 'vesicle' Model Object, while keeping record of the parent subsystem
% of added Species and Parameters

% Works both with TX-TL modeling toolbox and user-defined subsystems

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function BioSIMI_add_subsystem(target_obj,compartment_name,subsystem_call)

    if ~(isempty(subsystem_call.Architecture))

        % Rename compartment
        if (size(subsystem_call.Compartments,1)) == 1
            rename(subsystem_call.Compartments(1),compartment_name);
        else
            for i = 1:size(subsystem_call.Compartments,1)
                rename(subsystem_call.Compartments(i),string(compartment_name{i}));
            end
        end
        %% Rename model objects
        % Events cannot be renamed
        % Rename parameters
        for i = 1:size(subsystem_call.Parameters,1)
            j = size(target_obj.Parameters,1);
            rename(subsystem_call.Parameters(i),[subsystem_call.Name,'_',subsystem_call.Parameters(i).Name]);
        end
        % Rename reactions
        for i = 1:size(subsystem_call.Reactions,1)
            j = size(target_obj.Reactions,1);
            rename(subsystem_call.Reactions(i),[subsystem_call.Name,'_Reaction',num2str(i+j)]);
        end
        % Rules cannot be renamed
        % Rename species
        for i = 1:size(subsystem_call.Species,1)
            j = size(target_obj.Species,1);
            rename(subsystem_call.Species(i),[subsystem_call.Name,'_',subsystem_call.Species(i).Name]);
        end
        % Rename inputs if necessary (if TX-TL system is being added into vesicle)
        % Also rename parent compartment of input to 'compartment_name' if necessary
        if iscell(subsystem_call.Input)
            for j = 1:size(subsystem_call.Input,2)
                input_count = 0;
                for i = 1:size(subsystem_call.Species,1)
                    if strcmp(subsystem_call.Input{j}.Name,subsystem_call.Species(i).Name)
                        input_count = input_count + 1;
                    end
                end
                if input_count == 0
                    subsystem_call.Input{j}.Name = [subsystem_call.Name,'_',subsystem_call.Input{j}.Name];
                    if iscell(compartment_name)
                        subsystem_call.Input{j}.Parent.Name = compartment_name{1};
                    else
                        subsystem_call.Input{j}.Parent.Name = compartment_name;
                    end
                end
            end
        else
            input_count = 0;
            for i = 1:size(subsystem_call.Species,1)
                if strcmp(subsystem_call.Input.Name,subsystem_call.Species(i).Name)
                    input_count = input_count + 1;
                end
            end
            if input_count == 0
                subsystem_call.Input.Name = [subsystem_call.Name,'_',subsystem_call.Input.Name];
                if iscell(compartment_name)
                    subsystem_call.Input.Parent.Name = compartment_name{1}; % Assuming that compartment 'int' is the first one
                else
                    subsystem_call.Input.Parent.Name = compartment_name;
                end
            end
        end
        % Rename output if necessary (if TX-TL system is being added into vesicle)
        output_count = 0;
        for i = 1:size(subsystem_call.Species,1)
            if strcmp(subsystem_call.Output.Name,subsystem_call.Species(i).Name)
                output_count = output_count + 1;
            end
        end
        if output_count == 0
            subsystem_call.Output.Name = [subsystem_call.Name,'_',subsystem_call.Output.Name];
            if iscell(compartment_name)
                subsystem_call.Output.Parent.Name = compartment_name{1}; % Assuming that compartment 'int' is the first one
            else
                subsystem_call.Output.Parent.Name = compartment_name;
            end
        end
        %% Add events, parameters, reactions (and species) and rules to the parent model object
        % Add Events to parent model object
        if isempty(subsystem_call.Events)
            for i = 1:size(subsystem_call.Events,1)
                evts(i) = copyobj(subsystem_call.Events(i),target_obj);
            end
        else
            for i = 1:size(subsystem_call.Events,1)
                evts(i+size(target_obj.Events,1)) = copyobj(subsystem_call.Events(i),target_obj);
            end
        end
        % Add Parameters to parent model object
        if isempty(subsystem_call.Parameters)
            for i = 1:size(subsystem_call.Parameters,1)
                pars(i) = copyobj(subsystem_call.Parameters(i),target_obj);
            end
        else
            for i = 1:size(subsystem_call.Parameters,1)
                pars(i+size(target_obj.Parameters,1)) = copyobj(subsystem_call.Parameters(i),target_obj);
            end
        end
        % Add Reactions to parent model object
        if isempty(subsystem_call.Reactions)
            for i = 1:size(subsystem_call.Reactions,1)
                recs(i) = copyobj(subsystem_call.Reactions(i),target_obj);
            end
        else
            for i = 1:size(subsystem_call.Reactions,1)
                recs(i+size(target_obj.Reactions,1)) = copyobj(subsystem_call.Reactions(i),target_obj);
            end
        end
        % Add Rules to parent model object
        if isempty(subsystem_call.Rules)
            for i = 1:size(subsystem_call.Rules,1)
                ruls(i) = copyobj(subsystem_call.Rules(i),target_obj);
            end
        else
            for i = 1:size(subsystem_call.Reactions,1)
                ruls(i+size(target_obj.Reactions,1)) = copyobj(subsystem_call.Rules(i),target_obj);
            end
        end
        % There is no need to add used species, as they were added with
        % Reaction objects

        % We need to add species that are not used in reactions
        for i = 1:size(subsystem_call.Species,1)
            spec_count = 0;
            for j = 1:size(target_obj.Species,1)
                if ~strcmp(subsystem_call.Species(i).Name,target_obj.Species(j).Name)
                    spec_count = spec_count+1;
                end
            end
            if spec_count == size(target_obj.Species,1)
                subsystem_call.Species(i)
                for k = 1:size(target_obj.Compartments,1)
                    if strcmp(subsystem_call.Species(i).Parent.Name,target_obj.Compartments(k).Name)
                        specs(size(target_obj.Species,1)+1) = copyobj(subsystem_call.Species(i),target_obj.Compartments(k));
                    end
                end
            end
        end

    else
        disp('Given subsystem does not exist or is not in the scope!')
    end

end