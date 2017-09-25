%% 20/08/2017 Miroslav Gasparek
%% Definition of the function that adds subsystem to the model object
%% Serving as a prototype for creation of modularization framework of TX-TL modeling toolbox

function BioSIMI_add_subsystem_rename(target_obj,compartment_name,subsystem_call)

    if ~(isempty(subsystem_call.SubsystemType))
        
        %% Rename compartment
        if (size(subsystem_call.Compartments,1)) == 1
                rename(subsystem_call.Compartments(1),compartment_name);
        else
            for i = 1:size(subsystem_call.Compartments,1)
                rename(subsystem_call.Compartments(i),string(compartment_name(i)));
            end
        end
        %% Rename model objects
        % Rename events
        for i = 1:size(subsystem_call.Events,1)
            j = size(target_obj.Events,1);
            rename(subsystem_call.Events(i),['Event',num2str(i+j)]);
        end
        % Rename parameters
        for i = 1:size(subsystem_call.Parameters,1)
            j = size(target_obj.Parameters,1);
            rename(subsystem_call.Parameters(i),['Parameter',num2str(i+j)]);
        end
        % Rename reactions
        for i = 1:size(subsystem_call.Reactions,1)
            j = size(target_obj.Reactions,1);
            rename(subsystem_call.Reactions(i),['Reaction',num2str(i+j)]);
        end
        % Rename rules
        for i = 1:size(subsystem_call.Rules,1)
            j = size(target_obj.Rules,1);
            rename(subsystem_call.Rules(i),['Rule',num2str(i+j)]);
        end
        % Rename species
        for i = 1:size(subsystem_call.Species,1)
            j = size(target_obj.Species,1);
            rename(subsystem_call.Species(i),['Species',num2str(i+j)]);
        end

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
            % There is no need to add species, as they were added with
            % Reactions objects
        else 
            disp('Given subsystem does not exist or is not in the scope!')
    end
        
end