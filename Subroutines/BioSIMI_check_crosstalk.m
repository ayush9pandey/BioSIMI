%% 07/09/2017 Miroslav Gasparek & Vipul Singhal
% Definition of the function that searches for common species in the interconnection of two subsystems
% Serving as a prototype for creation of modularization framework of BioSIMI modeling toolbox


function [equal_species,pos1,pos2] = BioSIMI_check_crosstalk(final_subsystem)
    % Get component subsystems belonging to the final system
    
    for i = 1:size(final_subsystem.Components,2)
        subsystem(i) = final_subsystem.Components(i);
        string{i} = [subsystem(i).Name,'_'];
    end
    % Define string of  a subsystems' name and an underscore to be removed
%     string1 = [subsystem1.Name,'_'];
%     string2 = [subsystem2.Name,'_'];
    % Pre-allocate arrays for species' names
    for i = 1:size(final_subsystem.Components,2)
        str_array{i} = cell(1,size(final_subsystem.Species,1));
    end
%     str_array1 = cell(1,size(final_subsystem.Species,1));
%     str_array2 = cell(1,size(final_subsystem.Species,1));
    
    % Create array of names of the species
    for i = 1:size(final_subsystem.Components,2)
        for j = 1:size(final_subsystem.Species,1)
            if ~isempty(strfind(final_subsystem.Species(j).Name,string{i}))
                str_array{i}{j} = erase(final_subsystem.Species(j).Name,string{i});
            end
        end
    end
    % Delete empty entries in the cell of subsystem1 species' names
    for i = 1:size(final_subsystem.Components,2)
        emptyCells = cellfun('isempty',str_array{i});
        str_array{i}(emptyCells) = [];
    end
    
    % Create array of names of the species
%     for i = 1:size(final_subsystem.Species,1)
%         if ~isempty(strfind(final_subsystem.Species(i).Name,string2))
%             str_array2{i} = erase(final_subsystem.Species(i).Name,string2);
%         end
%     end
%     % Delete empty entries in the cell of subsystem2 species' names
%     emptyCells = cellfun('isempty',str_array2);
%     str_array2(emptyCells) = [];
    
    % Get names and positions of the same species
    for i = 1:size(final_subsystem.Components,2)
        [result1,p1,p2] = intersect(str_array{i},str_array{i+1},'stable');
        i = i+1;
        if (i < size(final_subsystem.Components,2))
            [equal_species,pos1,pos2] = intersect(result1,str_array{i+1},'stable');
        else
            equal_species = result1;
            pos1 = p1;
            pos2 = p2;
            break
        end
    end
end