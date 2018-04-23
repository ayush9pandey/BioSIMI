%%% 27/08/2017 Miroslav Gasparek
% Library of Simbiology model subsystems that can be initialized by
% 'txtl_make_subsystem' functions

% All the subsystems can be simply added to the Library by expanding the
% array 'subsystems_list'. The subsystem name in the array must be the same as name of
% the function that contanins the reactions of the subsystem and must be in
% the same folder

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

function Chosen_Subsystem = BioSIMI_SearchSubsystemLibrary(selected_subsystem_name)

subsystems_list = {
    'DiffusionIn',...       % Simple diffusion into cell - Transport System
    'DiffusionOut',...      % Simple diffusion out of the cell - Transport System
    'FacDiffIn',...         % Transporter protein-mediated facilitated diffusion into the cell - Transport System
    'FacDiffOut',...        % Transporter protein-mediated facilitated diffusion out of the cell - Transport System
    'MemChannelIn',...      % Membrane channel-mediated transport into the cell - Transport System
    'MemChannelOut',...     % Membrane channel-mediated transport out of the cell - Transport System 
    'DP',...                % Double-Phosphorylation Signaling Pathway - Signaling System
    'IFFL',...              % Incoherent Feed-Forward Loop - Computational/Regulatory System
    'ToggleSwitch',...      % Genetic toggle switch with two inputs - Computational/Regulatory System
};
    for i = 1:size(subsystems_list,2)
        if strcmp(selected_subsystem_name,subsystems_list(i))
%             Chosen_Subsystem = eval(string(subsystems_list(i)));
            Chosen_Subsystem = eval(char(cellstr(subsystems_list(i))));
        end
    end
end