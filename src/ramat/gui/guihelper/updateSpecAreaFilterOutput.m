function updateSpecAreaFilterOutput(viewer, dc)
%UPDATESPECAREAFILTEROUTPUT 

    arguments
        viewer SpecAreaDataViewer = [];
        dc DataContainer = [];
    end

    ax = viewer.UIAxes;

    % Check if handles have been provided
    if isempty(ax) || isempty(dc)
        return;
    end

    output = dc.FilterOutput;
    specdat = dc.Data;
    
    cla(ax, 'reset');
    
    % Set-Up Axes
    ax.XTick = [];
    ax.YTick = [];
    ax.XAxis.Label.delete();
    ax.YAxis.Label.delete();
        
    % Set Title
    string = sprintf("%s: %s of [%.0f - %.0f]", ...
        dc.DisplayName, ...
        dc.Filter.Operation, ...
        dc.Filter.Range(1), ...
        dc.Filter.Range(2));
    ax.Title.String = string;
    
    img = imagesc(ax, output);
    img.ButtonDownFcn = @(~,event) update_spec_area_cursor(specdat, event.IntersectionPoint, ax, viewer.get_main_axes());

    ax.DataAspectRatio = [1 1 1];
%     ax.XLim = [0.5, dc.XSize + 0.5];
%     ax.YLim = [0.5, dc.YSize + 0.5];
    
end

