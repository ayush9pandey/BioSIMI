%% 29/08/2017 Miroslav Gasparek
% Definition of a function that connects two subsystems by replacing the output(s)
% of subsystem(s) by input(s) of subsystem(s) that these specified subsystems are connected to 

% Function also creates new subsystem that represents interconnections of
% the previously defined subsystems

% Function enables analysis of subsystems with multiple inputs

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function Subsystem = BioSIMI_connect(target_obj,compartment_name,subsystems_in,subsystem_out,system_name)
        
        % Make distinction between number of inputs provided for one input
        % and multiple inputs

%% Execution for single input subsystem
    if (size(subsystems_in,1) == 1 && size(subsystems_in,2) == 1 && size(subsystem_out.Input,1) == 1 && size(subsystem_out.Input,2) == 1)
        
        % Define resulting system as object of class 'subsystem'
        Subsystem = subsystem;
        % Add subsystems comprising final system as Components of the final
        % system
        Subsystem.Components = [subsystems_in,subsystem_out];
        % Select the compartment of the final model object where reactions
        % are present
        for i = 1:size(target_obj.Compartments,1)
            if strcmp(target_obj.Compartments(i).Name,compartment_name)
                Compartment = target_obj.Compartments(i).Name;
            end
        end
        if isempty(Compartment)
            disp(['Compartment ',compartment_name,' does not exist in the model object!']);
        end
        
        % Find the index of the subsystem 1 output 'sub1_out' and the index
        % of subsystem 2 input 'sub2_in' in the species array and find
        % usages of subsystems_in.Output to be replaced
        for i = 1:size(target_obj.Species,1)
            if strcmp(subsystems_in.Output.Name,target_obj.Species(i).Name)
                sub1_out = i;
                [components,usages] = findUsages(target_obj.Species(i));
            elseif strcmp(subsystem_out.Input.Name,target_obj.Species(i).Name)
                sub2_in = i;
            end
        end
        % Amend the reaction rates so that species in first subsystem replaces the species
        % with this name in second subsystem
        for i = 1:size(usages,1)
            if strcmp(string(usages.Property(i)),'ReactionRate')
                % i
                for j = 1:size(target_obj.Reactions,1)
                    if strcmp(string(usages.Usage(i)),target_obj.Reactions(j).ReactionRate)
                        target_obj.Reactions(j).ReactionRate = strrep(target_obj.Reactions(j).ReactionRate,subsystems_in.Output.Name,subsystem_out.Input.Name);
                    end
                end
                % Amend the reactants and products so that species in first subsystem replaces the species
                % with this name in second subsystem
            elseif strcmp(string(usages.Property(i)),'Reaction')
                for j = 1:size(target_obj.Reactions,1)
                    if strcmp(string(usages.Usage(i)),target_obj.Reactions(j).Reaction)
                        for k = 1:size(target_obj.Reactions(j).Reactants,1)
                            if strcmp(target_obj.Reactions(j).Reactants(k).Name,subsystems_in.Output.Name)
                                rmreactant(target_obj.Reactions(j),target_obj.Species(sub1_out));
                                addreactant(target_obj.Reactions(j),target_obj.Species(sub2_in)); %% !!
                            end
                        end
                        for k = 1:size(target_obj.Reactions(j).Products,1)
                            if strcmp(target_obj.Reactions(j).Products(k).Name,subsystems_in.Output.Name)
                                rmproduct(target_obj.Reactions(j),target_obj.Species(sub1_out));
                                addproduct(target_obj.Reactions(j),target_obj.Species(sub2_in)); %% !!
                            end
                        end
                    end
                end
            end
        end
%         % Amend the reaction rates so that they contain input of second
%         % subsystem instead of output of first subsystem
%         for i = 1:size(target_obj.Reactions,1)
%             if ~isempty(strfind(target_obj.Reactions(i).ReactionRate,subsystems_in.Output.Name))
%                 target_obj.Reactions(i).ReactionRate = strrep(target_obj.Reactions(i).ReactionRate,subsystems_in.Output.Name,subsystem_out.Input.Name);
%             end
%         end
%        % Amend the reactants so that they contain input of second
%        % subsystem instead of output of first subsystem
%         for i = 1:size(target_obj.Reactions,1)
%             for j = 1:size(target_obj.Reactions(i).Reactants,1)
%                 if strcmp(target_obj.Reactions(i).Reactants(j).Name,subsystems_in.Output.Name)
%                     rmreactant(target_obj.Reactions(i),[Compartment,'.',subsystems_in.Output.Name]);
%                     addreactant(target_obj.Reactions(i),subsystem_out.Input);
%                 end   
%             end
%         end
%         % Amend the products so that they contain input of second
%         % subsystem instead of output of first subsystem
%         for i = 1:size(target_obj.Reactions,1)
%             for j = 1:size(target_obj.Reactions(i).Products,1)
%                 if strcmp(target_obj.Reactions(i).Products(j).Name,subsystems_in.Output.Name)        
%                     rmproduct(target_obj.Reactions(i),[Compartment,'.',subsystems_in.Output.Name]);
%                     addproduct(target_obj.Reactions(i),subsystem_out.Input);
%                 end
%             end        
%         end
        % Set initial amount of input of the second subsystem to 0
        for i = 1:size(target_obj.Species,1)
            if strcmp(target_obj.Species(i).Name,subsystem_out.Input.Name)
                target_obj.Species(i).InitialAmount = 0;
            end
        end
        
        % Set parameters of the final subsystem
        Subsystem.ModelObject = target_obj;
        Subsystem.Type = [subsystems_in.Type,' + ',subsystem_out.Type];
        Subsystem.Name = system_name;
        Subsystem.Architecture = [subsystems_in.Architecture,' + ',subsystem_out.Architecture];
        Subsystem.Compartments = target_obj.Compartments;
        Subsystem.Events = target_obj.Events;
        Subsystem.Parameters = target_obj.Parameters;
        Subsystem.Reactions = target_obj.Reactions;
        Subsystem.Rules = target_obj.Rules;
        Subsystem.Species = target_obj.Species;
        Subsystem.Input = subsystems_in.Input;
        Subsystem.Output = subsystem_out.Output;
        
        % Name the component subsystems
        Subsystem.Components(1).Name = subsystems_in.Name;
        Subsystem.Components(2).Name = subsystem_out.Name;
%% Exection for multiple input subsystems
    elseif (size(subsystems_in,1) == 1 && size(subsystems_in,2) ~= 1 && size(subsystem_out.Input,1) == 1 && size(subsystem_out.Input,2) ~= 1 && size(subsystems_in,2) == size(subsystem_out.Input,2))
        % Define resulting system as object of class 'subsystem'
        Subsystem = subsystem;
        % Select the compartment of the final model object where reactions
        % are present
        for i = 1:size(target_obj.Compartments,1)
            if strcmp(target_obj.Compartments(i).Name,compartment_name)
                Compartment = target_obj.Compartments(i).Name;
            end
        end
        if isempty(Compartment)
            disp(['Compartment ',compartment_name,' does not exist in the model object!']);
        end
        
        % Find the index of the subsystem 1 output 'sub1_out' and the index
        % of subsystem 2 input 'sub2_in' in the species array and find
        % usages of subsystems_in.Output to be replaced
        for q = 1:size(subsystems_in,2)
            for i = 1:size(target_obj.Species,1)
                if strcmp(subsystems_in{q}.Output.Name,target_obj.Species(i).Name)
                    sub1_out(q) = i;
                    [components{q},usages{q}] = findUsages(target_obj.Species(i));
                end
            end
            for i = 1:size(target_obj.Species,1)
                if strcmp(subsystem_out.Input{q}.Name,target_obj.Species(i).Name)
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
                    for j = 1:size(target_obj.Reactions,1)
                        if strcmp(string(usages{q}.Usage(i)),target_obj.Reactions(j).ReactionRate)
                            target_obj.Reactions(j).ReactionRate = strrep(target_obj.Reactions(j).ReactionRate,subsystems_in{q}.Output.Name,subsystem_out.Input{q}.Name);
                        end
                    end
                    % Amend the reactants and products so that species in first subsystem replaces the species
                    % with this name in second subsystem
                elseif strcmp(string(usages{q}.Property(i)),'Reaction')
                    for j = 1:size(target_obj.Reactions,1)
                        if strcmp(string(usages{q}.Usage(i)),target_obj.Reactions(j).Reaction)
                            for k = 1:size(target_obj.Reactions(j).Reactants,1)
                                if strcmp(target_obj.Reactions(j).Reactants(k).Name,subsystems_in{q}.Output.Name)
                                    rmreactant(target_obj.Reactions(j),target_obj.Species(sub1_out(q)));
                                    addreactant(target_obj.Reactions(j),target_obj.Species(sub2_in(q))); %% !!
                                end
                            end
                            for k = 1:size(target_obj.Reactions(j).Products,1)
                                if strcmp(target_obj.Reactions(j).Products(k).Name,subsystems_in{q}.Output.Name)
                                    rmproduct(target_obj.Reactions(j),target_obj.Species(sub1_out(q)));
                                    addproduct(target_obj.Reactions(j),target_obj.Species(sub2_in(q))); %% !!
                                end
                            end
                        end
                    end
                end
            end
        end
%         for q = 1:size(subsystems_in,2)
%             % Amend the reaction rates so that they contain input of second
%             % subsystem instead of output of first subsystem
%             for i = 1:size(target_obj.Reactions,1)
%                 if ~isempty(strfind(target_obj.Reactions(i).ReactionRate,subsystems_in{q}.Output.Name))
%                     target_obj.Reactions(i).ReactionRate = strrep(target_obj.Reactions(i).ReactionRate,subsystems_in{q}.Output.Name,subsystem_out.Input{q}.Name);
%                 end
%             end
%             % Amend the reactants so that they contain input of second
%             % subsystem instead of output of first subsystem
%             for i = 1:size(target_obj.Reactions,1)
%                 for j = 1:size(target_obj.Reactions(i).Reactants,1)
%                     if strcmp(target_obj.Reactions(i).Reactants(j).Name,subsystems_in{q}.Output.Name)
%                         rmreactant(target_obj.Reactions(i),[Compartment,'.',subsystems_in{q}.Output.Name]);
%                         addreactant(target_obj.Reactions(i),subsystem_out.Input{q});
%                     end   
%                 end
%             end
%             % Amend the products so that they contain input of second
%             % subsystem instead of output of first subsystem
%             for i = 1:size(target_obj.Reactions,1)
%                 for j = 1:size(target_obj.Reactions(i).Products,1)
%                     if strcmp(target_obj.Reactions(i).Products(j).Name,subsystems_in{q}.Output.Name)        
%                         rmproduct(target_obj.Reactions(i),[Compartment,'.',subsystems_in{q}.Output.Name]);
%                         addproduct(target_obj.Reactions(i),subsystem_out.Input{q});
%                     end
%                 end        
%             end
%             % Set initial amount of input into second subsystem to 0
%             for i = 1:size(target_obj.Species,1)
%                 if strcmp(target_obj.Species(i).Name,subsystem_out.Input{q}.Name)
%                     target_obj.Species(i).InitialAmount = 0;
%                 end
%             end
%         end

            % Set parameters of the final subsystem
            Subsystem.ModelObject = target_obj;
            % Set Type of the final system 
            %(contains all the subsystems in the final system)
                cell_Type = cell(1,size(subsystems_in,2));
            for q = 1:size(subsystems_in,2)
                cell_Type{q} = subsystems_in{q}.Type;
            end
            Subsystem.Type = ['(',strrep(strjoin(cell_Type,' '),' ',' + '),') + ',subsystem_out.Type];
            Subsystem.Name = system_name;                       % Assign Name to final Subsystem 
            % Set Architecture of the final system 
            %(contains architectures of all subsystems in the final system)
                cell_Architecture = cell(1,size(subsystems_in,2));
            for q = 1:size(subsystems_in,2)
                cell_Architecture{q} = subsystems_in{q}.Architecture;
            end
            Subsystem.Architecture = ['(',strrep(strjoin(cell_Architecture,' '),' ',' + '),') + ',subsystem_out.Architecture];
            Subsystem.Compartments = target_obj.Compartments;   % Assign Compartments to final Subsystem
            Subsystem.Events = target_obj.Events;               % Assign Events to final Subsystem
            Subsystem.Parameters = target_obj.Parameters;       % Assign Parameters to final Subsystem
            Subsystem.Reactions = target_obj.Reactions;         % Assign Reactions to final Subsystem
            Subsystem.Rules = target_obj.Rules;                 % Assign Rules to final Subsystem
            Subsystem.Species = target_obj.Species;             % Assign Species to final Subsystem
            
            Subsystem.Input = cell(1,size(subsystems_in,2));
            for q = 1:size(subsystems_in,2)                     % Assign Inputs to final Subsystem
                Subsystem.Input{q} = subsystems_in{q}.Input;    % (These Inputs are the inputs into individual subsystems)
            end
            Subsystem.Output = subsystem_out.Output;            % Assign Output to final Subsystem (Output of the subsystem_out)
            
            % Name the component subsystems
            Subsystem.Components = cell(1,size(subsystems_in,2));
            for q = 1:size(subsystems_in,2)
                Subsystem.Components{q} = subsystems_in{q};
            end
            Subsystem.Components{q+1} = subsystem_out;
    end
end
