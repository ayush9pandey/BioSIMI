%% 29/08/2017 Miroslav Gasparek
% Definition of the class 'subsystem' that contains infromation about
% SimBiology Objects requried for definition of the subsystem representing
% a specific biomolecular circuit

% Required subroutine for analysis of interconnected biomolecular subsystems
% in BioSIMI modeling toolbox

classdef subsystem
    properties (Access = public)
        ModelObject
        Type
        Name
        Architecture
        Compartments
        Events
        Parameters
        Reactions
        Rules
        Species
        Input
        Output
        SimSettings
        Components
    end
    methods
    end
end
