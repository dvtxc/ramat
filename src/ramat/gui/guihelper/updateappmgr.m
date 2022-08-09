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
        data_root = app.prj.data_root();
        analysis_result_root = app.prj.analysis_result_root();

        % Clear Tree
        a = tree.Children;
        a.delete;

        % Create Data Nodes
        gen_child_nodes(tree, data_root, app);
        
        % Create Analysis Result Nodes
        gen_child_nodes(tree, analysis_result_root, app);
        
    end % END PART 1

    %% Update Analysis Subsets
    
    if any(options.Parts == 2)
    
        tree = app.SubsetTree;

        % Clear Tree
        a = tree.Children;
        a.delete;

        for i = 1:numel(app.prj.analyses)
            subset = app.prj.analyses(i);

            subsetnode = uitreenode(tree, ...
                "Text", subset.display_name, ...
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
        if isempty(app.prj.analyses)
            return;
        end
        if isempty(app.prj.ActiveAnalysis)
            return;
        end

        % TO-DO: make dependent property of prj, make sure one
        % analysis subset is selected!
        activeSubset = app.prj.ActiveAnalysis;
        checkednodes = [];

        % Add groups
        for g = 1:numel(activeSubset.GroupSet)
            group = activeSubset.GroupSet(g);

            groupnode = uitreenode(tree, ...
                "Text", group.display_name, ...
                "NodeData", group);

            if ~isempty(group.children)
                % Group has DataContainer children

                for i = 1:numel(group.children)
                    data = group.children(i);

                    datanode = uitreenode(groupnode, ...
                        "Text", data.display_name, ...
                        "NodeData", data, ...
                        "ContextMenu", app.contxtSubsetTreeNode);

                    % Assign icon to node
                    switch (data.dataType)
                        case "SpecData"
                            % Spectral Data, evaluate the datasize
                            if data.Data.DataSize > 1
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

        
    end % END PART 3
    
end