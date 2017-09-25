%% 22/09/2017 Miroslav Gasparek
% Definition of a function that connects two subsystems by replacing the output(s)
% of subsystem(s) by input(s) of subsystem(s) that these specified subsystems are connected to

% Function also creates new subsystem that represents interconnections of
% the previously defined subsystems

% Function enables analysis of subsystems with multiple inputs

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

%% TO BE FINISHED FOR MULTIPLE INPUTS AND FOR MULTIPLE COMPARTMENTS
function Subsystem = BioSIMI_connect_new_object(model_obj_name,compartment_name,subsystems_in,subsystem_out,system_name)

% Make distinction between number of inputs provided for one input
% and multiple inputs

%% Execution for single input subsystem
    if (size(subsystems_in,1) == 1 && size(subsystems_in,2) == 1 && size(subsystem_out.Input,1) == 1 && size(subsystem_out.Input,2) == 1)

        % Rename compartments of the input subsystem
        if (size(subsystems_in.Compartments,1)) == 1
            rename(subsystems_in.Compartments(1),compartment_name{1});
        else
            for i = 1:size(subsystems_in.Compartments,1)
                rename(subsystems_in.Compartments(i),string(compartment_name{i}));
            end
        end
        % Rename compartments of the output subsystem
        if (size(subsystem_out.Compartments,1)) == 1
            rename(subsystem_out.Compartments(1),compartment_name{1});
        else
            for i = 1:size(subsystem_out.Compartments,1)
                rename(subsystem_out.Compartments(i),string(compartment_name{i}));
            end
        end

        % Create resulting system as object of class 'subsystem'
        Subsystem = subsystem;
        % Create a new SimBiology Object
        model_obj = sbiomodel(model_obj_name);
        % Add compartments to the created model object
        if (size(compartment_name,2) == 1)
            comp(i) = addcompartment(model_obj,compartment_name(i));
        else
            for i = 1:size(compartment_name,2)
                comp(i) = addcompartment(model_obj,compartment_name{i});
            end
        end
        % Add subsystems comprising final system as Components of the final
        % system
        Subsystem.Components = [subsystems_in,subsystem_out];
        
        % Add subsystems into new model object
        if (size(subsystems_in.Compartments,1) == 1)
            comp_in = subsystems_in.Compartments.Name;
            BioSIMI_add_subsystem(model_obj,comp_in,subsystems_in);
        else
            for i = 1:size(subsystems_in.Compartments,1)
                comp_in{i} = subsystems_in.Compartments(i).Name;
            end
            BioSIMI_add_subsystem(model_obj,comp_in,subsystems_in);
        end
        if (size(subsystem_out.Compartments,1) == 1)
            comp_out = subsystem_out.Compartments.Name;
            BioSIMI_add_subsystem(model_obj,subsystem_out.Compartments.Name,subsystem_out);
        else
            for i = 1:size(subsystem_out.Compartments,1)
                comp_out{i} = subsystem_out.Compartments(i).Name;
            end
            BioSIMI_add_subsystem(model_obj,comp_out,subsystem_out);
        end

        % Find the index of the subsystem 1 output 'sub1_out' and the index
        % of subsystem 2 input 'sub2_in' in the species array and find
        % usages of subsystems_in.Output to be replaced
        for i = 1:size(model_obj.Species,1)
            if strcmp(subsystems_in.Output.Name,model_obj.Species(i).Name)
                sub1_out = i;
                [components,usages] = findUsages(model_obj.Species(i));
            elseif strcmp(subsystem_out.Input.Name,model_obj.Species(i).Name)
                sub2_in = i;
            end
        end
        % Amend the reaction rates so that species in first subsystem replaces the species
        % with this name in second subsystem
        for i = 1:size(usages,1)
            if strcmp(string(usages.Property(i)),'ReactionRate')
                % i
                for j = 1:size(model_obj.Reactions,1)
                    if strcmp(string(usages.Usage(i)),model_obj.Reactions(j).ReactionRate)
                        model_obj.Reactions(j).ReactionRate = strrep(model_obj.Reactions(j).ReactionRate,subsystems_in.Output.Name,subsystem_out.Input.Name);
                    end
                end
        % Amend the reactants and products so that species in first subsystem replaces the species
        % with this name in second subsystem
            elseif strcmp(string(usages.Property(i)),'Reaction')
                for j = 1:size(model_obj.Reactions,1)
                    if strcmp(string(usages.Usage(i)),model_obj.Reactions(j).Reaction)
                        for k = 1:size(model_obj.Reactions(j).Reactants,1)
                            if strcmp(model_obj.Reactions(j).Reactants(k).Name,subsystems_in.Output.Name)
                                rmreactant(model_obj.Reactions(j),model_obj.Species(sub1_out));
                                addreactant(model_obj.Reactions(j),model_obj.Species(sub2_in)); %% !!
                            end
                        end
                        for k = 1:size(model_obj.Reactions(j).Products,1)
                            if strcmp(model_obj.Reactions(j).Products(k).Name,subsystems_in.Output.Name)
                                rmproduct(model_obj.Reactions(j),model_obj.Species(sub1_out));
                                addproduct(model_obj.Reactions(j),model_obj.Species(sub2_in)); %% !!
                            end
                        end
                    end
                end
            end
        end
        % Set initial amount of input of the second subsystem to 0
        for i = 1:size(model_obj.Species,1)
            if strcmp(model_obj.Species(i).Name,subsystem_out.Input.Name)
                model_obj.Species(i).InitialAmount = 0;
            end
        end

        % Set properties of the final subsystem
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
        %% Exection for multiple input subsystems
    elseif (size(subsystems_in,1) == 1 && size(subsystems_in,2) ~= 1 && size(subsystem_out.Input,1) == 1 && size(subsystem_out.Input,2) ~= 1 && size(subsystems_in,2) == size(subsystem_out.Input,2))

        % Rename compartments of the input subsystems
        for q = 1:size(subsystems_in,2)
            if (size(subsystems_in{q}.Compartments,1)) == 1
                rename(subsystems_in{q}.Compartments(1),compartment_name{1});
            else
                for i = 1:size(subsystems_in{q}.Compartments,1)
                    rename(subsystems_in{q}.Compartments(i),string(compartment_name{i}));
                end
            end
        end
        % Rename compartments of the output subsystem
        if (size(subsystem_out.Compartments,1)) == 1
            rename(subsystem_out.Compartments(1),compartment_name{1});
        else
            for i = 1:size(subsystem_out.Compartments,1)
                rename(subsystem_out.Compartments(i),string(compartment_name{i}));
            end
        end
        
        % Create resulting system as object of class 'subsystem'
        Subsystem = subsystem;
        % Create a new SimBiology Object
        model_obj = sbiomodel(model_obj_name);
        % Add compartments to the created model object
        if (size(compartment_name,2) == 1)
            comp(i) = addcompartment(model_obj,compartment_name(i));
        else
            for i = 1:size(compartment_name,2)
                comp(i) = addcompartment(model_obj,compartment_name{i});
            end
        end
        
        % Add subsystems comprising final system as Components of the final
        % system
        Subsystem.Components = cell(1,size(subsystems_in,2));
        for q = 1:size(subsystems_in,2)
            Subsystem.Components{q} = subsystems_in{q};
        end
        Subsystem.Components{q+1} = subsystem_out;

        % Add input subsystems into new model object
        for q = 1:size(subsystems_in,2)
            if (size(subsystems_in{q}.Compartments,1) == 1)
                comp_in = subsystems_in{q}.Compartments.Name;
                BioSIMI_add_subsystem(model_obj,comp_in,subsystems_in{q});
            else
                for i = 1:size(subsystems_in{q}.Compartments,1)
                    comp_in{i} = subsystems_in{q}.Compartments(i).Name;
                end
                BioSIMI_add_subsystem(model_obj,comp_in,subsystems_in{q});
            end
        end
        % Add output subsystem into new model object
        if (size(subsystem_out.Compartments,1) == 1)
            comp_out = subsystem_out.Compartments.Name;
            BioSIMI_add_subsystem(model_obj,subsystem_out.Compartments.Name,subsystem_out);
        else
            for i = 1:size(subsystem_out.Compartments,1)
                comp_out{i} = subsystem_out.Compartments(i).Name;
            end
            BioSIMI_add_subsystem(model_obj,comp_out,subsystem_out);
        end
        
        % Find the index of the subsystem 1 output 'sub1_out' and the index
        % of subsystem 2 input 'sub2_in' in the species array and find
        % usages of subsystems_in.Output to be replaced
        for q = 1:size(subsystems_in,2)
            for i = 1:size(model_obj.Species,1)
                if strcmp(subsystems_in{q}.Output.Name,model_obj.Species(i).Name)
                    sub1_out(q) = i;
                    [components{q},usages{q}] = findUsages(model_obj.Species(i));
                end
            end
            for i = 1:size(model_obj.Species,1)
                if strcmp(subsystem_out.Input{q}.Name,model_obj.Species(i).Name)
                    sub2_in(q) = i;
                end
            end
        end
        
        % Amend the reaction rates so that species in first subsystem replaces the species
        % with this name in second subsystem
        for q = 1:size(subsystems_in,2)
            for i = 1:size(usages{q},1)
                if strcmp(string(usages{q}.Property(i)),'ReactionRate')
                    % i
                    for j = 1:size(model_obj.Reactions,1)
                        if strcmp(string(usages{q}.Usage(i)),model_obj.Reactions(j).ReactionRate)
                            model_obj.Reactions(j).ReactionRate = strrep(model_obj.Reactions(j).ReactionRate,subsystems_in{q}.Output.Name,subsystem_out.Input{q}.Name);
                        end
                    end
        % Amend the reactants and products so that species in first subsystem replaces the species
        % with this name in second subsystem
                elseif strcmp(string(usages{q}.Property(i)),'Reaction')
                    for j = 1:size(model_obj.Reactions,1)
                        if strcmp(string(usages{q}.Usage(i)),model_obj.Reactions(j).Reaction)
                            for k = 1:size(model_obj.Reactions(j).Reactants,1)
                                if strcmp(model_obj.Reactions(j).Reactants(k).Name,subsystems_in{q}.Output.Name)
                                    rmreactant(model_obj.Reactions(j),model_obj.Species(sub1_out(q)));
                                    addreactant(model_obj.Reactions(j),model_obj.Species(sub2_in(q))); %% !!
                                end
                            end
                            for k = 1:size(model_obj.Reactions(j).Products,1)
                                if strcmp(model_obj.Reactions(j).Products(k).Name,subsystems_in{q}.Output.Name)
                                    rmproduct(model_obj.Reactions(j),model_obj.Species(sub1_out(q)));
                                    addproduct(model_obj.Reactions(j),model_obj.Species(sub2_in(q))); %% !!
                                end
                            end
                        end
                    end
                end
            end
        end
        % Set properties of the final subsystem
        Subsystem.ModelObject = model_obj;
        % Set Type of the final system
        %(contains all the subsystems in the final system)
        cell_Type = cell(1,size(subsystems_in,2));
        for q = 1:size(subsystems_in,2)
            cell_Type{q} = subsystems_in{q}.Type;
        end
        Subsystem.Type = ['(',strrep(strjoin(cell_Type,' '),' ',' + '),') + ',subsystem_out.Type];
        
        Subsystem.Name = system_name;
        
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
    end
end
