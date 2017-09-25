%% 13/09/2017 Miroslav Gasparek
% Definition of a function that adds SimBiology objects contained within 
% specific object of class 'subsystem' that has been created by 'BioSIMI_make_subsystem'
% into 'target_obj' Model Object, while keeping record of the parent subsystem
% of added Species and Parameters

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function BioSIMI_add_subsystem_species_only(target_obj,compartment_name,subsystem_call)
       
    if ~(isempty(subsystem_call.ModelObject))
        
        % Rename compartment
        if (size(subsystem_call.Compartments,1)) == 1
                rename(subsystem_call.Compartments(1),compartment_name);
        else
            for i = 1:size(subsystem_call.Compartments,1)
                rename(subsystem_call.Compartments(i),string(compartment_name(i)));
            end
        end
        %% Rename SimBiology objects
        %% Add species to the parent model object
            % Add Species to parent model object
                if isempty(target_obj.Species)
                    for i = 1:size(subsystem_call.Species,1)
                        specs_handle = get(subsystem_call.Species(i));
                        for j = 1:size(target_obj.Compartments,1)
                            if strcmp(target_obj.Compartments(j).Name,specs_handle.Parent.Name)
                                specs(i) = copyobj(subsystem_call.Species(i),target_obj.Compartments(j));
                                rename(target_obj.Species(i),[subsystem_call.Name,'_',target_obj.Species(i).Name]);
                            end
                        end
                    end
                else
                    specs_size = size(target_obj.Species,1);
                    for i = 1:size(subsystem_call.Species,1)
                        specs_handle = get(subsystem_call.Species(i));
                        for j = 1:size(target_obj.Compartments,1)
                            if strcmp(target_obj.Compartments(j).Name,specs_handle.Parent.Name)
                                specs(i+specs_size) = copyobj(subsystem_call.Species(i),target_obj.Compartments(j));
                                rename(target_obj.Species(i+specs_size),[subsystem_call.Name,'_',target_obj.Species(i+specs_size).Name]);
                            end
                        end
                    end
                end
                
                for i = 1:size(subsystem_call.Species,1)
                    rename(subsystem_call.Species(i),[subsystem_call.Name,'_',subsystem_call.Species(i).Name]);
                end
        else 
            disp('Given subsystem does not exist or is not in the scope!')
    end        
end