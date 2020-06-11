function data = importRaman(varargin)
%IMPORTRAMAN


%% LOAD FILES
if nargin == 0
    
    start_path = pwd;
    
    thisFolder = uigetdir(start_path);
    if thisFolder == 0
        return;
    end
else
    thisFolder = varargin{1};
end

consoleOutput = true;

if (nargin == 2)
    consoleOutput = false;
    app = varargin{2};
end
% SELECT SOURCE FOLDER AND SEARCH FOR CSV-FILES

writeBuffer = sprintf('Processing folder %s\n', thisFolder);
if (consoleOutput == true)
    fprintf('%s', writeBuffer);
else
    app.StatusTextArea.Value = [app.StatusTextArea.Value; writeBuffer];
end

filePattern = sprintf('%s/*.mat', thisFolder);
baseFileNames = dir(filePattern);
 
numberOfFiles = length(baseFileNames);
	
if numberOfFiles >= 1
	% Go through all those files.
	for f = 1 : numberOfFiles
		fullFileName = fullfile(thisFolder, baseFileNames(f).name);
		
		%% === START OF IMPORT CODE ===
		
		close all
        
        if (consoleOutput == true)
            clc
        else
            app.StatusTextArea.Value = "";
        end
        
        writeBuffer = sprintf('Processing file %d of %d\n',f,numberOfFiles);
        writeBuffer = append(writeBuffer, sprintf('%s\n', baseFileNames(f).name));
        writeBuffer = append(writeBuffer, sprintf('Importing Data\n'));
        if (consoleOutput == true)
            fprintf('%s', writeBuffer);
        else
            app.StatusTextArea.Value = [app.StatusTextArea.Value; writeBuffer];
            drawnow;
        end
        
        if (consoleOutput == true)
            data(f) = importSingleRamanGraph(fullFileName);
        else
            data(f) = importSingleRamanGraph(fullFileName,app);
        end
        		
		% === END OF IMPORT ===
	end
    
    
else
	fprintf('     Folder %s has no data files in it.\n', thisFolder);
end

% Fource output to column
data = data(:);
 
end
