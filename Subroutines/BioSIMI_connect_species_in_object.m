%% 29/08/2017 Miroslav Gasparek
% Definition of a function that connects two subsystems by replacing the output(s)
% of subsystem(s) by input(s) of subsystem(s) that these specified subsystems are connected to 

% Function also creates new subsystem that represents interconnections of
% the previously defined subsystems

% Function enables analysis of subsystems with multiple inputs

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

% If multiple input subsystems are inserted, they should be entered as a
% cell: subsystems_in = {input_subsystem1, input_subsyste2,...}

% This requires addition to existing model object 'target_obj'

function Subsystem = BioSIMI_connect_species_only(target_obj,compartment_name,subsystems_in,subsystem_out,system_name)
        
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
          
        % Amend the reaction rates so that they contain input of second
        % subsystem instead of output of first subsystem
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
        % Amend the products so that they contain input of second
        % subsystem instead of output of first subsystem
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
%        subsystems_in.Output.UserData = '';
        
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
        
        for q = 1:size(subsystems_in,2)
            % Amend the reaction rates so that they contain input of second
            % subsystem instead of output of first subsystem
%             for i = 1:size(target_obj.Reactions,1)
%                 if ~isempty(strfind(target_obj.Reactions(i).ReactionRate,subsystems_in{q}.Output.Name))
%                     target_obj.Reactions(i).ReactionRate = strrep(target_obj.Reactions(i).ReactionRate,subsystems_in{q}.Output.Name,subsystem_out.Input{q}.Name);
%                 end
%             end
            % Amend the reactants so that they contain input of second
            % subsystem instead of output of first subsystem
%             for i = 1:size(target_obj.Reactions,1)
%                 for j = 1:size(target_obj.Reactions(i).Reactants,1)
%                     if strcmp(target_obj.Reactions(i).Reactants(j).Name,subsystems_in{q}.Output.Name)
%                         rmreactant(target_obj.Reactions(i),[Compartment,'.',subsystems_in{q}.Output.Name]);
%                         addreactant(target_obj.Reactions(i),subsystem_out.Input{q});
%                     end   
%                 end
%             end
            % Amend the products so that they contain input of second
            % subsystem instead of output of first subsystem
%             for i = 1:size(target_obj.Reactions,1)
%                 for j = 1:size(target_obj.Reactions(i).Products,1)
%                     if strcmp(target_obj.Reactions(i).Products(j).Name,subsystems_in{q}.Output.Name)        
%                         rmproduct(target_obj.Reactions(i),[Compartment,'.',subsystems_in{q}.Output.Name]);
%                         addproduct(target_obj.Reactions(i),subsystem_out.Input{q});
%                     end
%                 end        
%             end
            % Set initial amount of input into second subsystem to 0
            % Remove the signature of 'Output' from the first subsystem
            for i = 1:size(target_obj.Species,1)
                if strcmp(target_obj.Species(i).Name,subsystem_out.Input{q}.Name)
                    target_obj.Species(i).InitialAmount = 0;
                end
            end
        end
        % Set Model Object of the final subsystem
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
 %           subsystems_in{q}.Output.UserData = '';
        end
        
        Subsystem.Output = subsystem_out.Output;            % Assign Output to final Subsystem (Output of the subsystem_out)
        % Name the component subsystems
        Subsystem.Components = cell(1,size(subsystems_in,2));
        for q = 1:size(subsystems_in,2)
            Subsystem.Components{q} = subsystems_in{q};
        end
        Subsystem.Components{q+1} = subsystem_out;
            
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
