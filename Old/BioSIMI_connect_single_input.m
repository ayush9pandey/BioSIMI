%% 29/08/2017 Miroslav Gasparek
% Definition of a function that connects two subsystems by replacing the output
% of the first subsystem by input of the second subsystem

% Function also creates new subsystem that represents interconnections of
% the previously defined subsystems

% Function enables analysis of subsystems with single input and single
% output

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function Subsystem = BioSIMI_connect_single_input(target_obj,compartment_name,subsystem1,subsystem2,system_name)
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
        Subsystem.Type = [subsystem1.Type,' + ',subsystem2.Type];
        Subsystem.Name = system_name;
        Subsystem.Architecture = [subsystem1.Architecture,' + ',subsystem2.Architecture];
        Subsystem.Compartments = target_obj.Compartments;
        Subsystem.Events = target_obj.Events;
        Subsystem.Parameters = target_obj.Parameters;
        Subsystem.Reactions = target_obj.Reactions;
        Subsystem.Rules = target_obj.Rules;
        Subsystem.Species = target_obj.Species;
        Subsystem.Input = subsystem1.Input;
        Subsystem.Output = subsystem2.Output;
        
        % Name the component subsystems
        Subsystem.Components(1).Name = subsystem1.Name;
        Subsystem.Components(2).Name = subsystem2.Name;
        
end
