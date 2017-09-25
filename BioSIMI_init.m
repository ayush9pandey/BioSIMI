%% 02/09/2017 Miroslav Gasparek
% A routine initializing BioSIMI module with tx-tl modeling framework
% TX-TL files must be in the same directory 

function BioSIMI_init
clear, clc, close all;

    disp('Welcome to BioSIMI modeling toolbox.');
    prompt = 'Do you want to use BioSIMI with TX-TL modeling toolbox? Y/N \n';
    str = input(prompt,'s');
        if strcmp(str,'Y')
            path1 = mfilename('fullpath');
            path2 = strrep(path1,mfilename,'');
            cd (path2);
            addpath([pwd '/Examples']);
            fprintf('BioSIMI Examples were added to path. \n');
            addpath([pwd '/Subroutines']);
            fprintf('BioSIMI Subroutines were added to path. \n');
            addpath([pwd '/Subroutines_InProgress']);
            fprintf('BioSIMI Subroutines_InProgress were added to path. \n');
            addpath([pwd '/Subsystems']);
            fprintf('BioSIMI Subsystems were added to path. \n');
            cd([pwd '/TX-TL']);
            txtl_init
            fprintf('TX-TL subroutines were added to path. \n');
            fprintf('Model subsystems interconnection in TX-TL using common procedures. \n');
            fprintf('For interconnection of subsystems, follow BioSIMI documentation. \n');
            pwd;
        elseif strcmp(str,'N')
            path1 = mfilename('fullpath');
            path2 = strrep(path1,mfilename,'');
            cd (path2);
            addpath([pwd '/Examples']);
            fprintf('BioSIMI Examples were added to path. \n');
            addpath([pwd '/Subroutines']);
            fprintf('BioSIMI Subroutines were added to path. \n');
            addpath([pwd '/Subroutines_InProgress']);
            fprintf('BioSIMI Subroutines_InProgress were added to path. \n');
            addpath([pwd '/Subsystems']);
            fprintf('BioSIMI Subsystems were added to path. \n');
            fprintf('TX-TL subroutines were NOT added to path. \n');
            fprintf('Model subsystems interconnection using pre-defined BioSIMI subsystems library. \n');
            fprintf('For further information, see BioSIMI documentation. \n');
            pwd;
        else
           fprintf('Incorrect input! \n'); 
        end
        
        
end