%% 01/09/2017 Miroslav Gasparek
% Definition of the function that plots input/output relationship
% in the interconnection of multiple subsystems
% Function can accept both simulations with single input/single output and
% multiple input/single output

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function BioSIMI_plot(final_system,simulation_data,varargin)
    if isempty(varargin)

        %% Single Input - Single Output (No additional species)
        if (size(final_system.Input,1) == 1 && size(final_system.Input,2) == 1)
            % Get simulation data
            input_data = simulation_data.selectbyname(final_system.Input.Name).Data;
            output_data = simulation_data.selectbyname(final_system.Output.Name).Data;
            time = simulation_data.Time;

            % Get legend data
            if isempty(final_system.Components)
                input_legend = ['Input: ',final_system.Input.Name];
            else
                input_str = final_system.Input.Name;
                [token,remain] = strtok(input_str, '_');
                [token,remain] = strtok(remain, '_');
                input_legend = token;
            end
            if isempty(final_system.Components)
                output_legend = ['Output: ',final_system.Output.Name];
            else
                output_str = final_system.Output.Name;
                [token,remain] = strtok(output_str, '_');
                [token,remain] = strtok(remain, '_');
                output_legend = token;
            end

            figure
            hold on
            plot(time,input_data,'--','LineWidth',2)
            plot(time,output_data,'r-','LineWidth',2)
            xlabel('Time [s]');
            ylabel('Species amounts [nM]');
            title(['Temporal response of output to input in "',final_system.Name,'" system']);
            legend(input_legend,output_legend,'Location','Best');
            hold off

            %% Multiple Inputs - Single Output (No additional species)
        elseif (size(final_system.Input,1) == 1 && size(final_system.Input,2) > 1)
            % Get simulation data
            input_data = cell(1,size(final_system.Input,2));
            input_legend = cell(1,size(final_system.Input,2));
            for q = 1:size(final_system.Input,2)
                input_data{q} = simulation_data.selectbyname(final_system.Input{q}.Name).Data;
            end
            output_data = simulation_data.selectbyname(final_system.Output.Name).Data;
            time = simulation_data.Time;

            % Get legend data
            % Get input legend data
            if isempty(final_system.Components)
                for q = 1:size(final_system.Input,2)
                    input_legend{q} = ['Input: ',final_system.Input{q}.Name];
                end
            else
                for q = 1:size(final_system.Input,2)
                    input_str{q} = final_system.Input{q}.Name;
                    [token,remain] = strtok(input_str{q}, '_');
                    [token,remain] = strtok(remain, '_');
                    input_legend{q} = token;
                end
            end
            % Get output legend data
            if isempty(final_system.Components)
                output_legend = ['Output: ',final_system.Output.Name];
            else
                output_str = final_system.Output.Name;
                [token,remain] = strtok(output_str, '_');
                [token,remain] = strtok(remain, '_');
                output_legend = token;
            end
            % Assemble final legend
            for i = 1:size(final_system.Input,2)
                final_legend{i} = input_legend{i};
            end
            final_legend{i+1} = output_legend;

            figure
            hold on
            for q = 1:size(final_system.Input,2)
                plot(time,input_data{q},'--','LineWidth',2)
            end
            plot(time,output_data,'r-','LineWidth',2)
            xlabel('Time [s]');
            ylabel('Species amounts [nM]');
            title(['Temporal response of output to input/s in "',final_system.Name,'" system']);
            legend(final_legend,'Location','Best')
            hold off
        end
    else
        %% Single Input - Single Output (With additional species)
        if (size(final_system.Input,1) == 1 && size(final_system.Input,2) == 1)
            % Get simulation data
            input_data = simulation_data.selectbyname(final_system.Input.Name).Data;
            output_data = simulation_data.selectbyname(final_system.Output.Name).Data;
            for k = 1:size(varargin,2)
                for i = 1:size(final_system.Species,1)
                    if strcmp(varargin(k),final_system.Species(i).Name)
                        species_data{k} = simulation_data.selectbyname(final_system.Species(i).Name).Data;
                    end
                end
            end
            time = simulation_data.Time;

            % Get legend data
            % Get input legend data
            if isempty(final_system.Components)
                input_legend = ['Input: ',final_system.Input.Name];
            else
                input_str = final_system.Input.Name;
                [token,remain] = strtok(input_str, '_');
                [token,remain] = strtok(remain, '_');
                input_legend = token;
            end
            % Get species legend data
            if isempty(final_system.Components)
                for k = 1:size(varargin,2)
                    for i = 1:size(final_system.Species,1)
                        if strcmp(varargin(k),final_system.Species(i).Name)
                            species_legend{k} = final_system.Species(i).Name;
                        end
                    end
                end
            else
                for k = 1:size(varargin,2)
                    for i = 1:size(final_system.Species,1)
                        if strcmp(varargin(k),final_system.Species(i).Name)
                            species_str{k} = final_system.Species(i).Name;
                            [token,remain] = strtok(species_str{k}, '_');
                            [token,remain] = strtok(remain, '_');
                            species_legend{k} = token;
                        end
                    end
                end
            end
            % Get output legend data
            if isempty(final_system.Components)
                output_legend = ['Output: ',final_system.Output.Name];
            else
                output_str = final_system.Output.Name;
                [token,remain] = strtok(output_str, '_');
                [token,remain] = strtok(remain, '_');
                output_legend = token;
            end
            % Assemble final legend
            for i = 1:size(final_system.Input,2)
                final_legend{i} = input_legend;
            end
            for j = 1:size(final_system.Input,2)
                final_legend{i+j} = species_legend{j};
            end
            final_legend{i+j+1} = output_legend;

            figure
            hold on
            plot(time,input_data,'--','LineWidth',2)
            for k = 1:size(varargin,2)
                plot(time,species_data{k},'-','LineWidth',2)
            end
            plot(time,output_data,'r-','LineWidth',2)
            xlabel('Time [s]');
            ylabel('Species amounts [nM]');
            title(['Temporal response of output to input in "',final_system.Name,'" system']);
            legend(final_legend,'Location','Best');
            hold off
            %% Multiple Inputs - Single Output (With additional species)
        elseif (size(final_system.Input,1) == 1 && size(final_system.Input,2) > 1)
            % Get simulation data
            input_data = cell(1,size(final_system.Input,2));
            for q = 1:size(final_system.Input,2)
                input_data{q} = simulation_data.selectbyname(final_system.Input{q}.Name).Data;
            end
            for k = 1:size(varargin,2)
                for i = 1:size(final_system.Species,1)
                    if strcmp(varargin(k),final_system.Species(i).Name)
                        species_data{k} = simulation_data.selectbyname(final_system.Species(i).Name).Data;
                    end
                end
            end
            output_data = simulation_data.selectbyname(final_system.Output.Name).Data;
            time = simulation_data.Time;

            % Get legend data
            % Get input legend data
            if isempty(final_system.Components)
                for q = 1:size(final_system.Input,2)
                    input_legend{q} = ['Input: ',final_system.Input{q}.Name];
                end
            else
                for q = 1:size(final_system.Input,2)
                    input_str{q} = final_system.Input{q}.Name;
                    [token,remain] = strtok(input_str{q}, '_');
                    [token,remain] = strtok(remain, '_');
                    input_legend{q} = token;
                end
            end
            % Get species legend data
            if isempty(final_system.Components)
                for k = 1:size(varargin,2)
                    for i = 1:size(final_system.Species,1)
                        if strcmp(varargin(k),final_system.Species(i).Name)
                            species_legend{k} = final_system.Species(i).Name;
                        end
                    end
                end
            else
                for k = 1:size(varargin,2)
                    if strcmp(varargin(k),final_system.Species(i).Name)
                        species_str{k} = final_system.Species(i).Name;
                        [token,remain] = strtok(species_str{k}, '_');
                        [token,remain] = strtok(remain, '_');
                        species_legend{k} = token;
                    end
                end
            end
            % Get output legend data
            if isempty(final_system.Components)
                output_legend = ['Output: ',final_system.Output.Name];
            else
                for i = 1:size(final_system.Components,2)
                    if ~isempty(strfind(final_system.Output.Name,final_system.Components(i).Name))
                        output_legend = ['Output: ',strrep(final_system.Output.Name,[final_system.Components(i).Name,'_'],'')];
                    end
                end
            end
            % Assemble final legend
            for i = 1:size(final_system.Input,2)
                final_legend{i} = input_legend{i};
            end
            for j = 1:size(varargin,2)
                final_legend{i+j} = species_legend{j};
            end
            final_legend{i+j+1} = output_legend;

            figure
            hold on
            for q = 1:size(final_system.Input,2)
                plot(time,input_data{q},'--','LineWidth',2)
            end
            for k = 1:size(varargin,2)
                plot(time,species_data{k},':','LineWidth',2)
            end
            plot(time,output_data,'r-','LineWidth',2)
            xlabel('Time [s]');
            ylabel('Species amounts [nM]');
            title(['Temporal response of output to input/s in "',final_system.Name,'" system']);
            legend(final_legend,'Location','Best');
            hold off
        end
    end
end