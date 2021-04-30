function save_dataset(options)
    %SAVE_DATASET Summary of this function goes here
    %   Detailed explanation goes here

    arguments
        options.App = [];
    end

    global prj;
    if isempty(prj)
        warning("No project to be saved");
        return
    end

    [filename, path] = uiputfile(...
        {'*.ramat','Raman MATLAB Dataset (*.ramat)'; ...
         '*.mat','MATLAB-files (*.mat)'});
    
    try 
        save( fullfile(path, filename), 'prj' );
    catch
        warning('Could not save project.');
        return
    end
    
    fprintf('Project saved successfully.');
    
end

