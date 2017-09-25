%% 15/08/2017 Miroslav Gasparek & Vipul Singhal
%% Script for prototyping of copying of properties of reactions from original model to a new one
%% Serving as a prototype for creation of modularization framework of TX-TL modeling toolbox


rename(IFFL_Subsystem.Compartments(1),'int')
for i = 1:size(IFFL_Subsystem.Events,1)
evts(i) = copyobj(IFFL_Subsystem.Events(i),vesicle)
end
for i = 1:size(IFFL_Subsystem.Parameters,1)
pars(i) = copyobj(IFFL_Subsystem.Parameters(i),vesicle)
end
for i = 1:size(IFFL_Subsystem.Reactions,1)
reacs(i) = copyobj(IFFL_Subsystem.Reactions(i),vesicle)
end
for i = 1:size(IFFL_Subsystem.Rules,1)
ruls(i) = copyobj(IFFL_Subsystem.Rules(i),vesicle)
end
%{
% Not necessary, as species are copied during the reaction
% If used in conjunction with addition of reactions, it will cause error
for i = 1:size(IFFL_Subsystem.Species,1)
spcs(i) = copyobj(IFFL_Subsystem.Species(i),vesicle)
end
%}
