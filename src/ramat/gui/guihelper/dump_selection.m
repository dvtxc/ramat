function varargout = dump_selection(selection)
    %DUMP_SELECTION Dumps selection to workspace
    %   Detailed explanation goes here
    
    arguments
        selection = [];
    end

    if nargout == 0
        selection
    elseif nargout == 1
        varargout = selection;
    else
        return
    end
end

