%% 27/08/2017 Miroslav Gasparek
%% Definition of the function that connects two species in the subsystem
%% Amends final system ready for simulation
%% Enables mutual interactions between chosen species that exist in both subsystems
%% Serving as a prototype for creation of modularization framework of TX-TL modeling toolbox

function Subsystem = BioSIMI_connect_input_output(target_obj,compartment_name,subsystem1,subsystem2,system_name)
        
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
        
        % Find Reactions and Reaction Rates in which species 2 to be
        % replaced has a role
        [components,usages] = findUsages(subsystem1.Output)
        
        % Amend the reaction rates so that species in first subsystem replaces the species
        % with this name in second subsystem
        for i = 1:size(usages,1)
            if strcmp(string(usages.Property(i)),'ReactionRate')
                i
                usages.Usage(i)
                for j = 1:size(target_obj.Reactions,1)
                    if strcmp(string(usages.Usage(i)),target_obj.Reactions(j).ReactionRate)
                       j
                       usages.Usage(i)
                       target_obj.Reactions(j).ReactionRate
                       target_obj.Reactions(j).ReactionRate = strrep(target_obj.Reactions(j).ReactionRate,subsystem1.Output.Name,subsystem2.Input.Name); 
                       target_obj.Reactions(j).ReactionRate
                    end
                end
            % Amend the reactants and products so that species in first subsystem replaces the species
            % with this name in second subsystem    
            elseif strcmp(string(usages.Property(i)),'Reaction')
                i
                usages.Usage(i)
                for j = 1:size(target_obj.Reactions,1)
                    if strcmp(string(usages.Usage(i)),target_obj.Reactions(j).Reaction)
                    j
                    target_obj.Reactions(j)
                        for k = 1:size(target_obj.Reactions(j).Reactants,1)
                            if strcmp(target_obj.Reactions(j).Reactants(k).Name,subsystem1.Output.Name)
                                rmreactant(target_obj.Reactions(j),[Compartment,'.',subsystem1.Output.Name]);
                                addreactant(target_obj.Reactions(j),subsystem2.Input); %% !!
                            end
                        end
                        for k = 1:size(target_obj.Reactions(j).Products,1)
                            if strcmp(target_obj.Reactions(j).Products(k).Name,subsystem1.Output.Name)
                                rmproduct(target_obj.Reactions(j),[Compartment,'.',subsystem1.Output.Name]);
                                addproduct(target_obj.Reactions(j),subsystem2.Input); %% !!
                            end
                        end
                    target_obj.Reactions(j)    
                    end
                end
            end
        end
       % Amend the reactants so that they contain input of second
       % subsystem instead of output of first subsystem
%         for i = 1:size(target_obj.Reactions,1)
%             for j = 1:size(target_obj.Reactions(i).Reactants,1)
%                 if strcmp(target_obj.Reactions(i).Reactants(j).Name,spec_name2)
%                     rmreactant(target_obj.Reactions(i),[Compartment,'.',spec_name2]);
%                     addreactant(target_obj.Reactions(i),final_system.Species(spec_index1)); %% !!
%                 end   
%             end
%         end
        % Amend the products so that they contain input of second
        % subsystem instead of output of first subsystem
%         for i = 1:size(target_obj.Reactions,1)
%             for j = 1:size(target_obj.Reactions(i).Products,1)
%                 if strcmp(target_obj.Reactions(i).Products(j).Name,spec_name2)        
%                     rmproduct(target_obj.Reactions(i),[Compartment,'.',spec_name2]);
%                     addproduct(target_obj.Reactions(i),final_system.Species(spec_index1));
%                 end
%             end        
%         end

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
end