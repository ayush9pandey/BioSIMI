%% 01/09/2017 Miroslav Gasparek
% Definition of the function that plots input/output relationship
% in the interconnection of multiple subsystems
% Function can accept both simulations with single input/single output and
% multiple input/single output

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function BioSIMI_plot(final_system,simulation_data,varargin)
    if isempty(varargin)
        if (size(final_system.Input,1) == 1 && size(final_system.Input,2) == 1)
            input_data = simulation_data.selectbyname(final_system.Input.Name).Data;
            output_data = simulation_data.selectbyname(final_system.Output.Name).Data;
            time = simulation_data.Time;
            
            figure
            hold on
            plot(time,input_data,'--','LineWidth',2)
            plot(time,output_data,'r-','LineWidth',2)
            xlabel('Time [s]');
            ylabel('Amount of species [nM]');
            title(['Temporal response of output to input in "',final_system.Name,'" system']);
            legend(['Input: ',strrep(final_system.Input.Name,'_','|')],['Output: ',strrep(final_system.Output.Name,'_','|')],'Location','Best');
            hold off
            
        elseif (size(final_system.Input,1) == 1 && size(final_system.Input,2) > 1)
            input_data = cell(1,size(final_system.Input,2));
            input_legend = cell(1,size(final_system.Input,2));
            for q = 1:size(final_system.Input,2)
                input_data{q} = simulation_data.selectbyname(final_system.Input{q}.Name).Data;
                input_legend{q} = ['Input: ',strrep(final_system.Input{q}.Name,'_','|')];
            end
            output_data = simulation_data.selectbyname(final_system.Output.Name).Data;
            time = simulation_data.Time;
            final_legend = [input_legend, ['Output: ',strrep(final_system.Output.Name,'_','|')]];
            
            figure
            hold on
            for q = 1:size(final_system.Input,2)
                plot(time,input_data{q},'--','LineWidth',2)
            end
            plot(time,output_data,'r-','LineWidth',2)
            xlabel('Time [s]');
            ylabel('Amount of species [molecules]');
            title(['Temporal response of output to input/s in "',final_system.Name,'" system']);
            legend(final_legend,'Location','Best');
            hold off
        end
    else
        if (size(final_system.Input,1) == 1 && size(final_system.Input,2) == 1)
            input_data = simulation_data.selectbyname(final_system.Input.Name).Data;
            output_data = simulation_data.selectbyname(final_system.Output.Name).Data;
            for k = 1:size(varargin,2)
                for i = 1:size(final_system.Species,1)
                    if strcmp(varargin(k),final_system.Species(i).Name)
                        species_data{k} = simulation_data.selectbyname(final_system.Species(i).Name).Data;
                        species_legend{k} = final_system.Species(i).Name;
                    end
                end
            end
            time = simulation_data.Time;
            
            figure
            hold on
            plot(time,input_data,'--','LineWidth',2)
            for k = 1:size(varargin,2)
                plot(time,species_data{k},':','LineWidth',2)
            end
            plot(time,output_data,'r-','LineWidth',2)
            xlabel('Time [s]');
            ylabel('Amount of species [nM]');
            title(['Temporal response of output to input in "',final_system.Name,'" system']);
            legend(['Input: ',strrep(final_system.Input.Name,'_','|')],['Output: ',strrep(final_system.Output.Name,'_','|')],'Location','Best');
            hold off
            
        elseif (size(final_system.Input,1) == 1 && size(final_system.Input,2) > 1)
            input_data = cell(1,size(final_system.Input,2));
            input_legend = cell(1,size(final_system.Input,2));
            for q = 1:size(final_system.Input,2)
                input_data{q} = simulation_data.selectbyname(final_system.Input{q}.Name).Data;
                input_legend{q} = ['Input: ',strrep(final_system.Input{q}.Name,'_','|')];
            end
            output_data = simulation_data.selectbyname(final_system.Output.Name).Data;
            for k = 1:size(varargin,2)
                for i = 1:size(final_system.Species,1)
                    if strcmp(varargin(k),final_system.Species(i).Name)
                        species_data{k} = simulation_data.selectbyname(final_system.Species(i).Name).Data;
                        species_legend{k} = final_system.Species(i).Name;
                    end
                end
            end
            time = simulation_data.Time;
            final_legend = [input_legend, species_legend, ['Output: ',strrep(final_system.Output.Name,'_','|')]];
            
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
            ylabel('Amount of species [molecules]');
            title(['Temporal response of output to input/s in "',final_system.Name,'" system']);
            legend(final_legend,'Location','Best');
            hold off
        end
    end
end