function deleteItems(items, app)
%DELETEITEMS Deletes items and updates gui managers

    % Call destructor
    items.delete();
    
    % Update manager
    app.updatemgr();
    
end

