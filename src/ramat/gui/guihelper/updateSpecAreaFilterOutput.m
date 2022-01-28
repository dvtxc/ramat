function updateSpecAreaFilterOutput(app)
%UPDATESPECAREAFILTEROUTPUT 
    ax = app.UIAxes;
    dc = app.DataCon;
    output = dc.FilterOutput;
    
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
    
    imagesc(ax, output );

    ax.DataAspectRatio = [1 1 1];
%     ax.XLim = [0.5, dc.XSize + 0.5];
%     ax.YLim = [0.5, dc.YSize + 0.5];
    
end

