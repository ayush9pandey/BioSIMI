%% 27/08/2017 Miroslav Gasparek & Vipul Singhal

% Definition of the function that connects two subsystems, while preserving the names of the species
% Creates final system ready for simulation
% Enables mutual interactions between particular species in both subsystems
% Serving as a prototype for creation of modularization framework of BioSIMI modeling toolbox


%% Does not work, needs to be finished!
function Subsystem = BioSIMI_connect_all_species(target_obj,compartment_name,subsystem1,subsystem2,system_name,varargin)        
    
    minArgs = 5;
    maxArgs = 6;
    narginchk(minArgs,maxArgs);
    
    if nargin == 5
        
        % Define resulting system as object of class 'subsystem'
        Subsystem = subsystem;
        % Add subsystems comprising final system as Components of the final
        % system
        Subsystem.Components = [subsystem1,subsystem2];
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
        % Amend the reaction rates so that they contain input of second
        % subsystem instead of output of first subsystem
        for i = 1:size(target_obj.Reactions,1)
            if ~isempty(strfind(target_obj.Reactions(i).ReactionRate,subsystem1.Output.Name))
                target_obj.Reactions(i).ReactionRate = strrep(target_obj.Reactions(i).ReactionRate,subsystem1.Output.Name,subsystem2.Input.Name);
            end
        end
       % Amend the reactants so that they contain input of second
       % subsystem instead of output of first subsystem
        for i = 1:size(target_obj.Reactions,1)
            for j = 1:size(target_obj.Reactions(i).Reactants,1)
                if strcmp(target_obj.Reactions(i).Reactants(j).Name,subsystem1.Output.Name)
                    rmreactant(target_obj.Reactions(i),[Compartment,'.',subsystem1.Output.Name]);
                    addreactant(target_obj.Reactions(i),subsystem2.Input);
                end   
            end
        end
        % Amend the products so that they contain input of second
        % subsystem instead of output of first subsystem
        for i = 1:size(target_obj.Reactions,1)
            for j = 1:size(target_obj.Reactions(i).Products,1)
                if strcmp(target_obj.Reactions(i).Products(j).Name,subsystem1.Output.Name)        
                    rmproduct(target_obj.Reactions(i),[Compartment,'.',subsystem1.Output.Name]);
                    addproduct(target_obj.Reactions(i),subsystem2.Input);
                end
            end        
        end
        % Set initial amount of input into second subsystem to 0
        for i = 1:size(target_obj.Species,1)
            if strcmp(target_obj.Species(i).Name,subsystem2.Input.Name)
                target_obj.Species(i).InitialAmount = 0;
            end
        end
        
        % Set parameters of the final subsystem
        Subsystem.ModelObject = target_obj;
        Subsystem.SubsystemType = [subsystem1.SubsystemType,' + ',subsystem2.SubsystemType];
        Subsystem.SubsystemName = system_name;
        Subsystem.Compartments = target_obj.Compartments;
        Subsystem.Events = target_obj.Events;
        Subsystem.Parameters = target_obj.Parameters;
        Subsystem.Reactions = target_obj.Reactions;
        Subsystem.Rules = target_obj.Rules;
        Subsystem.Species = target_obj.Species;
        Subsystem.Input = subsystem1.Input;
        Subsystem.Output = subsystem2.Output;
        
        % Name the component subsystems
        Subsystem.Components(1).SubsystemName = subsystem1.SubsystemName;
        Subsystem.Components(2).SubsystemName = subsystem2.SubsystemName;
%%    
    elseif(nargin == 6 && strcmp(varargin,'ConnectAllSpecies'))
         disp('I got here and one day I will connect them all')
        % Define resulting system as object of class 'subsystem'
        Subsystem = subsystem;
        % Add subsystems comprising final system as Components of the final
        % system
        Subsystem.Components = [subsystem1,subsystem2];
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
        % Amend the reaction rates so that they contain input of second
        % subsystem instead of output of first subsystem
        for i = 1:size(target_obj.Reactions,1)
            if ~isempty(strfind(target_obj.Reactions(i).ReactionRate,subsystem1.Output.Name))
                target_obj.Reactions(i).ReactionRate = strrep(target_obj.Reactions(i).ReactionRate,subsystem1.Output.Name,subsystem2.Input.Name);
            end
        end
       % Amend the reactants so that they contain input of second
       % subsystem instead of output of first subsystem
        for i = 1:size(target_obj.Reactions,1)
            for j = 1:size(target_obj.Reactions(i).Reactants,1)
                if strcmp(target_obj.Reactions(i).Reactants(j).Name,subsystem1.Output.Name)
                    rmreactant(target_obj.Reactions(i),[Compartment,'.',subsystem1.Output.Name]);
                    addreactant(target_obj.Reactions(i),subsystem2.Input);
                end   
            end
        end
        % Amend the products so that they contain input of second
        % subsystem instead of output of first subsystem
        for i = 1:size(target_obj.Reactions,1)
            for j = 1:size(target_obj.Reactions(i).Products,1)
                if strcmp(target_obj.Reactions(i).Products(j).Name,subsystem1.Output.Name)        
                    rmproduct(target_obj.Reactions(i),[Compartment,'.',subsystem1.Output.Name]);
                    addproduct(target_obj.Reactions(i),subsystem2.Input);
                end
            end        
        end
        % Set initial amount of input into second subsystem to 0
        for i = 1:size(target_obj.Species,1)
            if strcmp(target_obj.Species(i).Name,subsystem2.Input.Name)
                target_obj.Species(i).InitialAmount = 0;
            end
        end
        
        % Find and delete unused components
        rarray = findUnusedComponents(target_obj);
        for i = 1:size(rarray,1)
            rhandle = get(rarray(i));
            if (strcmp(rhandle.Type,'species') || strcmp(rhandle.Type,'parameters'))
                delete(rarray(i));
            end
        end
        % Set parameters of the final subsystem
        Subsystem.ModelObject = target_obj;
        Subsystem.SubsystemType = [subsystem1.SubsystemType,' + ',subsystem2.SubsystemType];
        Subsystem.SubsystemName = system_name;
        Subsystem.Compartments = target_obj.Compartments;
        Subsystem.Events = target_obj.Events;
        Subsystem.Parameters = target_obj.Parameters;
        Subsystem.Reactions = target_obj.Reactions;
        Subsystem.Rules = target_obj.Rules;
        Subsystem.Species = target_obj.Species;
        Subsystem.Input = subsystem1.Input;
        Subsystem.Output = subsystem2.Output;
        
        % Name the component subsystems
        Subsystem.Components(1).SubsystemName = subsystem1.SubsystemName;
        Subsystem.Components(2).SubsystemName = subsystem2.SubsystemName;
        
        %% Rename model objects

        
    end
end