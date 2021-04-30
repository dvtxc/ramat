function prj = load_dataset(options)
    %OPEN Summary of this function goes here
    %   Detailed explanation goes here
    
    arguments
        options.App = []
    end
    
    % Check whether we already have the global prj variable set
    global prj
    if isempty(prj)
        warning("No initialisation performed.");
        return
    end
    
    % TO-DO: declare app handle global
    if (exist('app', 'var') && isempty(options.App))
        options.App = app;
    end
    
    % Show UI dialog
    [file,path,indx] = uigetfile( ...
        {'*.ramat','Raman MATLAB Dataset (*.ramat)'; ...
        '*.mat','MATLAB Files (*.mat)'; ...
        '*.*',  'All Files (*.*)'}, ...
        'Select a Data Set');
    fullPath = fullfile(path, file);
    
    % Load Dataset
    try
        load(fullPath, 'prj');
    catch
        warning("Invalid file");
        return
    end
    
%     Set name of project (in case dataset file has been renamed)
    prj.Name = file;
    
    % Update GUI data trees
    if ~isempty(options.App)
        app.updatemgr
        
        % Set UI window title
        app.DVRamanToolUIFigure.Name = app.prj.Name;
    end
    
end

