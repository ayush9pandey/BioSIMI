%%% 07/09/2017 Miroslav Gasparek
% Definition of the function that initializes subsystem with multiple inputs
% from existing SimBiology model that can be accessed in the library of the
% subsystems accessed through function 'BioSIMI_SearchSubsystemLibrary'

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function Subsystem = BioSIMI_make_subsystem(sub_name,input,output,subsystem_name)
                % Code used if inserted subsystem is created from library of
                % subsystems created. Subsystem is then inserted as string
                % or char array
                if (strcmp(string(class(sub_name)),'string') || strcmp(string(class(sub_name)),'char'))
                    % Search the library of subsystems
                    SubsystemModelObj = BioSIMI_SearchSubsystemLibrary(sub_name);
                    % Create object Subsystem of class subsystem and assign
                    % values to it
                    Subsystem = subsystem;
                    Subsystem.ModelObject = SubsystemModelObj;
                    Subsystem.Type = SubsystemModelObj.UserData;
                    Subsystem.Name = subsystem_name;
                    Subsystem.Architecture = SubsystemModelObj.Name;
                    Subsystem.Compartments = SubsystemModelObj.Compartments;
                    Subsystem.Events = SubsystemModelObj.Events;
                    Subsystem.Parameters = SubsystemModelObj.Parameters;
                    Subsystem.Reactions = SubsystemModelObj.Reactions;
                    Subsystem.Rules = SubsystemModelObj.Rules;
                    Subsystem.Species = SubsystemModelObj.Species;
                    Subsystem.SimSettings = getconfigset(SubsystemModelObj);
                % Code used if inserted subsystem is created in TX-TL
                % Modeling toolbox. Subsystem is inserted as Model Object
                elseif (strcmp(string(class(sub_name)),'SimBiology.Model'))
                    SubsystemModelObj = sub_name;
                    Subsystem = subsystem;
                    Subsystem.ModelObject = SubsystemModelObj;
                    Subsystem.ModelObject.UserData = SubsystemModelObj.UserData;
                    Subsystem.Type = 'TX-TL';
                    Subsystem.Name = subsystem_name;
                    Subsystem.Architecture = SubsystemModelObj.Name;
                    Subsystem.Compartments = SubsystemModelObj.Compartments;
                    % Subsystem.Events = SubsystemModelObj.Events;
                    % Subsystem.Parameters = SubsystemModelObj.Parameters;
                    % Subsystem.Reactions = SubsystemModelObj.Reactions;
                    % Subsystem.Rules = SubsystemModelObj.Rules;
                    Subsystem.Species = SubsystemModelObj.Species;
                    % Subsystem.SimSettings = getconfigset(SubsystemModelObj);
                end
                % Takes care of case with multiple inputs
                if iscellstr(input)
                    Subsystem.Input = cell(1,size(input,2));
                    for j = 1:size(input,2)
                        for i = 1:size(Subsystem.Species,1)
                            if strcmp(Subsystem.Species(i).Name,input(j))
                                Subsystem.Input{j} = SubsystemModelObj.Species(i);
                                % Subsystem.Input{j}.Name =[subsystem_name,'_',Subsystem.Input.Name];
                            end
                        end
                    end
                % Takes care of case with single input
                else
                    for i = 1:size(Subsystem.Species,1)
                        if strcmp(Subsystem.Species(i).Name,input)
                            Subsystem.Input = SubsystemModelObj.Species(i);
                        end
                    end
                    % Subsystem.Input.Name =[subsystem_name,'_',Subsystem.Input.Name];
                end
                    if(isempty(Subsystem.Input))
                        disp('Input: No such species present in the selected subsystem!')
                    end
                for i = 1:size(Subsystem.Species,1)
                    if strcmp(Subsystem.Species(i).Name,output)
                        Subsystem.Output = SubsystemModelObj.Species(i);
                    end
                end
                    if(isempty(Subsystem.Output))
                        disp('Output: No such species present in the selected subsystem!')
                    end
end