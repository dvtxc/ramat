function gen_child_nodes(parent_node, group, app)
    %GEN_CHILD_NODES Recursive function to generate child nodes in the data
    %manager tree
    
    arguments
        parent_node;
        group;
        app;
    end

    % Generate node for current group
    group_node = uitreenode(parent_node, ...
                "Text", group.name, ...
                "NodeData", group, ...
                "Icon", "Folder_24.png");

    % Call recursively for all child groups
    for i = 1:numel(group.child_groups)
        gen_child_nodes(group_node, group.child_groups(i), app);
    end

    % Generate data container nodes
    num_children = numel(group.children);

    for j = 1:num_children
        data = group.children(j);
        datanode = uitreenode(group_node, ...
            "Text", data.display_name, ...              % Set Tree Text Label
            "NodeData", data, ...                       % Set Handle to DataContainer
            "ContextMenu", app.contxtDataMgrTreeNode);

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

            case "ImageData"
                datanode.Icon = "TDImage.png";

            otherwise
                datanode.Icon = "default.png";
        end

    end


end