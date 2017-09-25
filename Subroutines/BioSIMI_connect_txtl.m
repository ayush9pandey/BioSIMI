%% 13/09/2017 Miroslav Gasparek
% Definition of a function that connects two subsystems by replacing the output(s)
% of subsystem(s) by input(s) of subsystem(s) that these specified subsystems are connected to

% Function is used for interconnection of TX-TL subsystems! 

% Function also creates new subsystem that represents interconnections of
% the previously defined subsystems and creates a new model object that
% contains all the species

% Function enables analysis of subsystems with multiple inputs

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

% If multiple input subsystems are inserted, they should be entered as a
% cell: subsystems_in = {input_subsystem1, input_subsystem2,...}

function Subsystem = BioSIMI_connect_txtl(model_obj_name,compartment_name,subsystems_in,subsystem_out,system_name)
        
        % Makes distinction between number of inputs provided for one input
        % and multiple inputs

%% Execution for single input subsystem
    if (size(subsystems_in,1) == 1 && size(subsystems_in,2) == 1 && size(subsystem_out.Input,1) == 1 && size(subsystem_out.Input,2) == 1)
        
        % Rename compartments of the input subsystem
        if (size(subsystems_in.Compartments,1)) == 1
            rename(subsystems_in.Compartments(1),compartment_name);
        else
            for i = 1:size(subsystems_in.Compartments,1)
                rename(subsystems_in.Compartments(i),string(compartment_name(i)));
            end
        end
        % Rename compartments of the output subsystem
        if (size(subsystem_out.Compartments,1)) == 1
            rename(subsystem_out.Compartments(1),compartment_name);
        else
            for i = 1:size(subsystem_out.Compartments,1)
                rename(subsystems_out.Compartments(i),string(compartment_name(i)));
            end
        end
        
        % Create resulting system as object of class 'subsystem'
        Subsystem = subsystem;
        % Create a new SimBiology Object
        model_obj = sbiomodel(model_obj_name);
        % Add compartments to the created model object
        for i = 1:size(compartment_name,1)
            comp(i) = addcompartment(model_obj,compartment_name);
        end
        % Add subsystems comprising final system as Components of the final
        % system
        Subsystem.Components = [subsystems_in,subsystem_out];
        % Select the compartment of the final model object where reactions
        % are present
        for i = 1:size(model_obj.Compartments,1)
            if strcmp(model_obj.Compartments(i).Name,compartment_name)
                Compartment = model_obj.Compartments(i).Name;
            end
        end
        if isempty(Compartment)
            error(['Compartment ',compartment_name,' does not exist in the model object!']);
        end
        
        % Add Species to parent model object
        for q = 1:size(Subsystem.Components,2)
            if isempty(model_obj.Species)
                for i = 1:size(subsystems_in.Species,1)
                    specs_handle = get(subsystems_in.Species(i));
                    for j = 1:size(model_obj.Compartments,1)
                        if strcmp(model_obj.Compartments(j).Name,specs_handle.Parent.Name)
                            specs(i) = copyobj(subsystems_in.Species(i),model_obj.Compartments(j));
                            rename(model_obj.Species(i),[subsystems_in.Name,'_',model_obj.Species(i).Name]);
                        end
                    end
                end
            else
                specs_size = size(model_obj.Species,1);
                for i = 1:size(subsystem_out.Species,1)
                    specs_handle = get(subsystem_out.Species(i));
                    for j = 1:size(model_obj.Compartments,1)
                        if strcmp(model_obj.Compartments(j).Name,specs_handle.Parent.Name)
                            specs(i+specs_size) = copyobj(subsystem_out.Species(i),model_obj.Compartments(j));
                            rename(model_obj.Species(i+specs_size),[subsystem_out.Name,'_',model_obj.Species(i+specs_size).Name]);
                        end
                    end
                end
            end
        end
        % Add prefix of input subsystem's name to the name of particular
        % species in the subsystem
        for i = 1:size(subsystems_in.Species,1)
            rename(subsystems_in.Species(i),[subsystems_in.Name,'_',subsystems_in.Species(i).Name]);
        end
        % Add prefix of output subsystem's name to the name of particular
        % species in the subsystem
        for i = 1:size(subsystem_out.Species,1)
            rename(subsystem_out.Species(i),[subsystem_out.Name,'_',subsystem_out.Species(i).Name]);
        end          
        % Set initial amount of input of the second subsystem to 0
        for i = 1:size(model_obj.Species,1)
            if strcmp(model_obj.Species(i).Name,subsystem_out.Input.Name)
                model_obj.Species(i).InitialAmount = 0;
            end
        end
        % Set parameters of the final subsystem
        Subsystem.ModelObject = model_obj;
        Subsystem.Type = [subsystems_in.Type,' + ',subsystem_out.Type];
        Subsystem.Name = system_name;
        Subsystem.Architecture = [subsystems_in.Architecture,' + ',subsystem_out.Architecture];
        Subsystem.Compartments = model_obj.Compartments;
        Subsystem.Events = model_obj.Events;
        Subsystem.Parameters = model_obj.Parameters;
        Subsystem.Reactions = model_obj.Reactions;
        Subsystem.Rules = model_obj.Rules;
        Subsystem.Species = model_obj.Species;
        Subsystem.Input = subsystems_in.Input;
        Subsystem.Output = subsystem_out.Output;
        % Name the component subsystems
        Subsystem.Components(1).Name = subsystems_in.Name;
        Subsystem.Components(2).Name = subsystem_out.Name;
        
        % Add user data containing information for creation of simulation
        % into final subsystem
        % The most important info is 'DNAinfo' and this is concatenated
        % into one cell containing info from multiple subsystems
        % Information about 'ReactionConfig', 'FirstRun' and 'Vesicule' are
        % taken from the first subsystem, as it is assumed that these are
        % the same for all used subsystems
        Subsystem.ModelObject.UserData.ReactionConfig = subsystems_in.ModelObject.UserData.ReactionConfig;
        Subsystem.ModelObject.UserData.DNAinfo = [subsystems_in.ModelObject.UserData.DNAinfo, subsystem_out.ModelObject.UserData.DNAinfo];
        Subsystem.ModelObject.UserData.FirstRun = subsystems_in.ModelObject.UserData.FirstRun;
        Subsystem.ModelObject.UserData.Vesicule = subsystems_in.ModelObject.UserData.Vesicule;
        
%% Exection for multiple input subsystems
    elseif (size(subsystems_in,1) == 1 && size(subsystems_in,2) ~= 1 && size(subsystem_out.Input,1) == 1 && size(subsystem_out.Input,2) ~= 1 && size(subsystems_in,2) == size(subsystem_out.Input,2))

        % Rename compartments of the input subsystem
        for q = 1:size(subsystems_in,2)
            if (size(subsystems_in{q}.Compartments,1)) == 1
                rename(subsystems_in{q}.Compartments(1),compartment_name);
            else
                for i = 1:size(subsystems_in{q}.Compartments,1)
                    rename(subsystems_in{q}.Compartments(i),string(compartment_name(i)));
                end
            end
            % Rename compartments of the output subsystem
            if (size(subsystem_out.Compartments,1)) == 1
                rename(subsystem_out.Compartments(1),compartment_name);
            else
                for i = 1:size(subsystem_out.Compartments,1)
                    rename(subsystems_out.Compartments(i),string(compartment_name(i)));
                end
            end
        end
        % Create resulting system as object of class 'subsystem'
        Subsystem = subsystem;
        % Create a new SimBiology Object
        model_obj = sbiomodel(model_obj_name);
        % Add compartments to the created model object
        for i = 1:size(compartment_name,1)
            comp(i) = addcompartment(model_obj,compartment_name);
        end
        % Add subsystems comprising final system as Components of the final
        % system
        Subsystem.Components = cell(1,size(subsystems_in,2));
        for q = 1:size(subsystems_in,2)
            Subsystem.Components{q} = subsystems_in{q};
        end
        Subsystem.Components{q+1} = subsystem_out;
        
        % Select the compartment of the final model object where reactions
        % are present
        for i = 1:size(model_obj.Compartments,1)
            if strcmp(model_obj.Compartments(i).Name,compartment_name)
                Compartment = model_obj.Compartments(i).Name;
            end
        end
        if isempty(Compartment)
            error(['Compartment ',compartment_name,' does not exist in the model object!']);
        end
        
        % Add Species of the input subsystems to the parent model object
        for q = 1:(size(Subsystem.Components,2)-1)
            if isempty(model_obj.Species)
                for i = 1:size(subsystems_in{q}.Species,1)
                    specs_handle = get(subsystems_in{q}.Species(i));
                    for j = 1:size(model_obj.Compartments,1)
                        if strcmp(model_obj.Compartments(j).Name,specs_handle.Parent.Name)
                            specs(i) = copyobj(subsystems_in{q}.Species(i),model_obj.Compartments(j));
                            rename(model_obj.Species(i),[subsystems_in{q}.Name,'_',model_obj.Species(i).Name]);
                        end
                    end
                end
            else
                specs_size = size(model_obj.Species,1);
                for i = 1:size(subsystems_in{q}.Species,1)
                    specs_handle = get(subsystems_in{q}.Species(i));
                    for j = 1:size(model_obj.Compartments,1)
                        if strcmp(model_obj.Compartments(j).Name,specs_handle.Parent.Name)
                            specs(i+specs_size) = copyobj(subsystems_in{q}.Species(i),model_obj.Compartments(j));
                            rename(model_obj.Species(i+specs_size),[subsystems_in{q}.Name,'_',model_obj.Species(i+specs_size).Name]);
                        end
                    end
                end
            end
        end
        
        % Add Species of the output subsystem to the parent model object
        if isempty(model_obj.Species)
            for i = 1:size(subsystem_out.Species,1)
                specs_handle = get(subsystem_out.Species(i));
                for j = 1:size(model_obj.Compartments,1)
                    if strcmp(model_obj.Compartments(j).Name,specs_handle.Parent.Name)
                        specs(i) = copyobj(subsystem_out.Species(i),model_obj.Compartments(j));
                        rename(model_obj.Species(i),[subsystem_out.Name,'_',model_obj.Species(i).Name]);
                    end
                end
            end
        else
            specs_size = size(model_obj.Species,1);
            for i = 1:size(subsystem_out.Species,1)
                specs_handle = get(subsystem_out.Species(i));
                for j = 1:size(model_obj.Compartments,1)
                    if strcmp(model_obj.Compartments(j).Name,specs_handle.Parent.Name)
                        specs(i+specs_size) = copyobj(subsystem_out.Species(i),model_obj.Compartments(j));
                        rename(model_obj.Species(i+specs_size),[subsystem_out.Name,'_',model_obj.Species(i+specs_size).Name]);
                    end
                end
            end
        end
        
        % Add prefix of input subsystem's name to the name of particular
        % species in the subsystem
        for q = 1:size(subsystems_in,2)
            for i = 1:size(subsystems_in{q}.Species,1)
                rename(subsystems_in{q}.Species(i),[subsystems_in{q}.Name,'_',subsystems_in{q}.Species(i).Name]);
            end
        end
        % Add prefix of output subsystem's name to the name of particular
        % species in the subsystem
        for i = 1:size(subsystem_out.Species,1)
            rename(subsystem_out.Species(i),[subsystem_out.Name,'_',subsystem_out.Species(i).Name]);
        end
        % Set initial amount of input into second subsystem to 0
        % Remove the signature of 'Output' from the first subsystem
        for q = 1:size(subsystem_out.Input,2)
            for i = 1:size(model_obj.Species,1)
                if strcmp(model_obj.Species(i).Name,subsystem_out.Input{q}.Name)
                    model_obj.Species(i).InitialAmount = 0;
                end
            end
        end
        % Set parameters of the final subsystem
        Subsystem.ModelObject = model_obj;
        % Set Type of the final system
        %(contains all the subsystems in the final system)
        cell_Type = cell(1,size(subsystems_in,2));
        for q = 1:size(subsystems_in,2)
            cell_Type{q} = subsystems_in{q}.Type;
        end
        Subsystem.Type = ['(',strrep(strjoin(cell_Type,' '),' ',' + '),') + ',subsystem_out.Type];
        % Assign Name to final Subsystem
        Subsystem.Name = system_name;                       
        % Set Architecture of the final system
        %(contains architectures of all subsystems in the final system)
        cell_Architecture = cell(1,size(subsystems_in,2));
        for q = 1:size(subsystems_in,2)
            cell_Architecture{q} = subsystems_in{q}.Architecture;
        end
        Subsystem.Architecture = ['(',strrep(strjoin(cell_Architecture,' '),' ',' + '),') + ',subsystem_out.Architecture];
        Subsystem.Compartments = model_obj.Compartments;
        Subsystem.Events = model_obj.Events;
        Subsystem.Parameters = model_obj.Parameters;
        Subsystem.Reactions = model_obj.Reactions;
        Subsystem.Rules = model_obj.Rules;
        Subsystem.Species = model_obj.Species;
        % Assign Inputs to final Subsystem
        % (These Inputs are the inputs into individual subsystems)
        Subsystem.Input = cell(1,size(subsystems_in,2));
        for q = 1:size(subsystems_in,2)                     
            Subsystem.Input{q} = subsystems_in{q}.Input;    
        end
        % Assign Output to final Subsystem (Output of the subsystem_out)
        Subsystem.Output = subsystem_out.Output;
        
        % Add user data containing information for creation of simulation
        % into final subsystem
        % The most important info is 'DNAinfo' and this is concatenated
        % into one cell containing info from multiple subsystems
        % Information about 'ReactionConfig', 'FirstRun' and 'Vesicule' are
        % taken from the first subsystem, as it is assumed that these are
        % the same for all used subsystems
        Subsystem.ModelObject.UserData.ReactionConfig = subsystems_in{1}.ModelObject.UserData.ReactionConfig;
        DNAinfo_cell = subsystems_in{1}.ModelObject.UserData.DNAinfo;
        for q = 1:(size(subsystems_in,2)-1)
            DNAinfo_cell = [DNAinfo_cell, subsystems_in{q+1}.ModelObject.UserData.DNAinfo];    
        end
        Subsystem.ModelObject.UserData.DNAinfo = [DNAinfo_cell,subsystem_out.ModelObject.UserData.DNAinfo];
        Subsystem.ModelObject.UserData.FirstRun = subsystems_in{1}.ModelObject.UserData.FirstRun;
        Subsystem.ModelObject.UserData.Vesicule = subsystems_in{1}.ModelObject.UserData.Vesicule;
    end
end
