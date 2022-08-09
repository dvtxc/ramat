function update_app_selection_changed(app, event)
    %UPDATE_APP_SELECTION_CHANGED Update app, after selection in
    %the data manager has changed
    %
    %   Input arguments:
    %       app     app handle
    %       event   matlab.ui.eventdata.SelectedNodesChangedData
    %

    arguments
        app ramatguiapp;
        event matlab.ui.eventdata.SelectedNodesChangedData;
    end

    % Get selected nodes    
    selectedNodes = event.SelectedNodes;

    % Check for homogeneity
    classes = cellfun(@(x) string(class(x)), {selectedNodes.NodeData}');
    if ~all(classes(1) == classes)
        % Inhomogeneous selection, revert selection
        event.Source.SelectedNodes = event.PreviousSelectedNodes;
        return;

    end
     
    % Get associated data containers
    nodeData = vertcat( selectedNodes.NodeData );

    % Update data items tree
    update_data_items_tree(app, nodeData);

    % Check if non-data-containing things have been selected
    if classes(1) == "Group"
        return;
    end
    if isempty(nodeData)
        return;
    end
    if ~(all( vertcat( nodeData.dataType ) == "SpecData" ) || (numel(nodeData) == 1 && nodeData.dataType == "ImageData" ))
        return;
    end               

    % Open dialogs for specdata large area scans
    if (numel(nodeData) == 1)
        % Actions for single selections: 
        
        if (class(nodeData) == "DataContainer")
                        
            % Spectral data is selected
            if (nodeData.dataType == "SpecData")                   
                
                % AREA SCANS:
                if (nodeData.Data.DataSize > 1)
                    % Area Spectra Data Opened -> open filter window
                    

                    if isempty(app.OpenedDialogs.SpectralAreaDataViewer) || ~isvalid(app.OpenedDialogs.SpectralAreaDataViewer)
                        % Open new data viewer
                        app.OpenedDialogs.SpectralAreaDataViewer = SpecAreaDataViewer(app, nodeData);
                        
                    else
                        % Update data viewer
                        app.OpenedDialogs.SpectralAreaDataViewer.DataCon = nodeData;
                        app.OpenedDialogs.SpectralAreaDataViewer.update();
                        
                    end
                end
                
            end
            
        elseif (class(nodeData) == "PCAResult")
                   
            % If node is an analysis result, set this to the current active
            % analysis result
            % PCA Result is selected
            if (nodeData.dataType == "PCA")
                
                pcares = nodeData;
                
                % Set Active Analysis Result and prepare for analysis
                app.prj.ActiveAnalysisResult = pcares;
                app.TabGroup.SelectedTab = app.PCATab;
                app.PCADescription.Value = pcares.Description;
                
                % Plot
                updateScoresScatterPlot(app);
                
            end
            
        end
        
    end
    
    %% UPDATE PLOTTING
    
    % TO-DO: create superclass for all containers and implement plot method there
    % TEMPORARY WORKAROUND:
    
    
    % END of temporary workaround
    
    % Invoke plot method of selected data containers
    if app.StackedPlotCheckBox.Value
        plot_type = "Stacked";
    else
        plot_type = "Overlaid";
    end

    ax = app.UIPreviewAxes;
    nodeData.plot(Axes=ax,PlotType=plot_type);
            
end

