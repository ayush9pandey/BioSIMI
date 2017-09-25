%% 27/08/2017 Miroslav Gasparek
% Definition of a function that "connects" two species in different
% subsystems after the final subsystem has been created

% "Connection" of two species means that species 2 is replaced by species 1

% Function creates new subsystem such that it contains user-defined
% species that are present in both subsystems

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function Subsystem = BioSIMI_replace_species(target_obj,compartment_name,spec_name1,spec_name2,final_system,Subsystem_Name)
        
        % Define resulting system as object of class 'subsystem'
        Subsystem = subsystem;
        % Add subsystems contained in the final system as Components of the final
        % system
        Subsystem.Components = final_system.Components;
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
        
        % Find the Species1 in the array of Species 
        for i = 1:size(final_system.Species,1)
            if strcmp(final_system.Species(i).Name,spec_name1)
                spec_index1 = i;
            end
        end
        % Find the Species2 in the array of Species 
        for i = 1:size(final_system.Species,1)
            if strcmp(final_system.Species(i).Name,spec_name2)
                spec_index2 = i;
            end
        end
        
        % Find Reactions and Reaction Rates in which species 2 to be
        % replaced has a role
        [~,usages] = findUsages(final_system.Species(spec_index2));
        
        % Amend the reaction rates so that species in first subsystem replaces the species
        % with this name in second subsystem
        for i = 1:size(usages,1)
            if strcmp(string(usages.Property(i)),'ReactionRate')
                % i
                for j = 1:size(target_obj.Reactions,1)
                    if strcmp(string(usages.Usage(i)),target_obj.Reactions(j).ReactionRate)
                       target_obj.Reactions(j).ReactionRate = strrep(target_obj.Reactions(j).ReactionRate,spec_name2,spec_name1); 
                    end
                end
            % Amend the reactants and products so that species in first subsystem replaces the species
            % with this name in second subsystem    
            elseif strcmp(string(usages.Property(i)),'Reaction')
                for j = 1:size(target_obj.Reactions,1)
                    if strcmp(string(usages.Usage(i)),target_obj.Reactions(j).Reaction)
                        for k = 1:size(target_obj.Reactions(j).Reactants,1)
                            if strcmp(target_obj.Reactions(j).Reactants(k).Name,spec_name2)
                                rmreactant(target_obj.Reactions(j),[Compartment,'.',spec_name2]);
                                addreactant(target_obj.Reactions(j),final_system.Species(spec_index1)); %% !!
                            end
                        end
                        for k = 1:size(target_obj.Reactions(j).Products,1)
                            if strcmp(target_obj.Reactions(j).Products(k).Name,spec_name2)
                                rmproduct(target_obj.Reactions(j),[Compartment,'.',spec_name2]);
                                addproduct(target_obj.Reactions(j),final_system.Species(spec_index1)); %% !!
                            end
                        end
                    end
                end
            end
        end
%        % Amend the reactants so that they contain input of second
%        % subsystem instead of output of first subsystem
%         for i = 1:size(target_obj.Reactions,1)
%             for j = 1:size(target_obj.Reactions(i).Reactants,1)
%                 if strcmp(target_obj.Reactions(i).Reactants(j).Name,spec_name2)
%                     rmreactant(target_obj.Reactions(i),[Compartment,'.',spec_name2]);
%                     addreactant(target_obj.Reactions(i),final_system.Species(spec_index1)); %% !!
%                 end   
%             end
%         end
%         % Amend the products so that they contain input of second
%         % subsystem instead of output of first subsystem
%         for i = 1:size(target_obj.Reactions,1)
%             for j = 1:size(target_obj.Reactions(i).Products,1)
%                 if strcmp(target_obj.Reactions(i).Products(j).Name,spec_name2)        
%                     rmproduct(target_obj.Reactions(i),[Compartment,'.',spec_name2]);
%                     addproduct(target_obj.Reactions(i),final_system.Species(spec_index1));
%                 end
%             end        
%         end
        
        % Set initial amount of species 1 that replaces  2 to the 
        % sum of initial amounts of species replacing the other species and species being replaced
        for i = 1:size(target_obj.Species,1)
            if strcmp(target_obj.Species(i).Name,spec_name1)
                target_obj.Species(i).InitialAmount = final_system.Species(spec_index1).InitialAmount + final_system.Species(spec_index2).InitialAmount;
            end
        end
        % Set initial amount of species 2 replaced by species 1 to zero
        for i = 1:size(target_obj.Species,1)
            if strcmp(target_obj.Species(i).Name,spec_name2)
                target_obj.Species(i).InitialAmount = 0;
            end
        end
        
        % Set parameters of the final subsystem
        Subsystem.ModelObject = target_obj;
        Subsystem.Type = final_system.Type;
        Subsystem.Name = Subsystem_Name;
        Subsystem.Architecture = final_system.Architecture;
        Subsystem.Compartments = target_obj.Compartments;
        Subsystem.Events = target_obj.Events;
        Subsystem.Parameters = target_obj.Parameters;
        Subsystem.Reactions = target_obj.Reactions;
        Subsystem.Rules = target_obj.Rules;
        Subsystem.Species = target_obj.Species;
        Subsystem.Input = final_system.Input;
        Subsystem.Output = final_system.Output;
        % Name the component subsystems
        Subsystem.Components(1).Name = Subsystem.Components(1).Name;
        Subsystem.Components(2).Name = Subsystem.Components(2).Name;
end