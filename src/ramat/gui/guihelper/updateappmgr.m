function updateappmgr(app, options)
    %UPDATEMGR
    %   Updates GUI Data Managers
    
    arguments
        app;
        options.Parts = [1, 2, 3]; % Parts to update
    end
    
    
    %% Update Data Manager
    
    if any(options.Parts == 1)
    
        tree = app.DataMgrTree;

        % Clear Tree
        a = tree.Children;
        a.delete;

        % Create node to store measurements
        measurementsnode = uitreenode(tree,"Text","Measurements");
        analysisresultsnode = uitreenode(tree, "Text", "Analysis Results");

        % Populate Measurements with Data Groups
        for i = 1:numel(app.prj.GroupSet)
            group = app.prj.GroupSet(i);

            groupnode = uitreenode(measurementsnode, ...
                "Text", group.Name, ...
                "NodeData", group, ...
                "Icon", "Folder_24.png");

            % Populate the group
            num_children = numel(group.Children);

            if num_children > 0
                for j = 1:num_children
                    data = group.Children(j);
                    datanode = uitreenode(groupnode, ...
                        "Text", data.DisplayName, ...  % Set Tree Text Label
                        "NodeData", data, ...   % Set Handle to DataContainer
                        "ContextMenu", app.contxtDataMgrTreeNode);

                    % Assign icon to node
                    switch (data.dataType)
                        case "SpecData"
                            % Spectral Data, evaluate the datasize
                            if data.DataSize > 1
                                % Spectral Data of a scanned area
                                datanode.Icon = "TDGraph_0.png";
                            else
                                % Single Spectrum
                                datanode.Icon = "TDGraph_2.png";
                            end

                        case "TextData"
                            datanode.Icon = "TDText.png";

                        case "ImageData"
                            datanode.Icon = "TDImage.png";

                        otherwise
                            datanode.Icon = "default.png";
                    end

                end
            end
        end

        % Populate Analysis Results
        for i = 1:numel(app.prj.AnalysisResults)
            result = app.prj.AnalysisResults(i);

            resultnode = uitreenode(analysisresultsnode, ...
                "Text", result.DisplayName, ...
                "NodeData", result);
        end
        
    end % END PART 1

    %% Update Analysis Subsets
    
    if any(options.Parts == 2)
    
        tree = app.SubsetTree;

        % Clear Tree
        a = tree.Children;
        a.delete;

        for i = 1:numel(app.prj.AnalysisSet)
            subset = app.prj.AnalysisSet(i);

            subsetnode = uitreenode(tree, ...
                "Text", subset.DisplayName, ...
                "NodeData", subset);
        end
        
    end % END PART 2

    %% Update Analysis Items
    
    if any(options.Parts == 3)

        tree = app.SubsetItemsTree;

        % clear Tree
        a = tree.Children;
        a.delete;

        % Are there any subsets
        if (~isempty(app.prj.AnalysisSet) && ~isempty(app.prj.ActiveAnalysis))
            % TO-DO: make dependent property of prj, make sure one
            % analysis subset is selected!
            activeSubset = app.prj.ActiveAnalysis;
            
            checkednodes = [];

            % Add groups
            for g = 1:numel(activeSubset.GroupSet)
                group = activeSubset.GroupSet(g);

                groupnode = uitreenode(tree, ...
                    "Text", group.DisplayName, ...
                    "NodeData", group);

                if ~isempty(group.Children)
                    % Group has DataContainer children

                    for i = 1:numel(group.Children)
                        data = group.Children(i);

                        datanode = uitreenode(groupnode, ...
                            "Text", data.DisplayName, ...
                            "NodeData", data, ...
                            "ContextMenu", app.contxtSubsetTreeNode);

                        % Assign icon to node
                        switch (data.dataType)
                            case "SpecData"
                                % Spectral Data, evaluate the datasize
                                if data.DataSize > 1
                                    % Spectral Data of a scanned area
                                    datanode.Icon = "TDGraph_0.png";
                                else
                                    % Single Spectrum
                                    datanode.Icon = "TDGraph_2.png";
                                end

                            case "TextData"
                                datanode.Icon = "TDText.png";
                            otherwise
                                datanode.Icon = "default";
                        end
                        
                        % Evaluate whether the node should be checked and
                        % add to list of checked nodes
                        if any(activeSubset.Selection == data)
                            checkednodes = [checkednodes; datanode];
                        end

                    end
                end

            end

            % Set Checked nodes based on Analysis.Selection
            tree.CheckedNodes = checkednodes;
            
            % Add uncategorised data
            % Removed
    %                 groupnode = uitreenode(tree, ...
    %                     "Text", "Ungrouped");
    %                 
    %                 for i = 1:numel(activeSubset.DataSet)
    %                     data = activeSubset.DataSet(i);
    %                     
    %                     datanode = uitreenode(groupnode, ...
    %                         "Text", data.DisplayName, ...
    %                         "NodeData", data, ...
    %                         "ContextMenu", app.contxtSubsetTreeNode);
    %                 end

        end
        
    end % END PART 3
    
end