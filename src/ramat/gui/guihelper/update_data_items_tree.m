function update_data_items_tree(app, datacontainer)
    %UPDATE_DATA_ITEMS_TREE Summary of this function goes here
    %   Detailed explanation goes here
    
    tree = app.DataItemsTree;

    % Clear Tree
    a = tree.Children;
    a.delete;

    % Can only show info for one datacontainer
    if numel(datacontainer) > 1
        dc_node = uitreenode(tree,Text="Multiple Data Containers");
        return
    end

    % Cannot show info for non-datacontainers
    if class(datacontainer) ~= "DataContainer"
        dc_node = uitreenode(tree,Text="No Data Container selected");
        return
    end

    % Show data container node
    dc_node = uitreenode(tree, ...
        Text=datacontainer.display_name, ...
        NodeData=datacontainer);

    % Show every data item in container
    for item = datacontainer.children
        item_display_text = item.Type + " - " + item.name;
        item_node = uitreenode(dc_node, ...
            Text=item_display_text, ...
            NodeData=item);
    end

    % Expand tree
    expand(tree, 'all');

end

