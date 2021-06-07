function updateSpecAreaFilterOutput(app)
%UPDATESPECAREAFILTEROUTPUT 
    ax = app.UIAxes;
    dc = app.DataCon;
    output = dc.FilterOutput;
    
    % Set-Up Axes
    ax.XTick = [];
    ax.YTick = [];
    ax.XAxis.Label.delete();
    ax.YAxis.Label.delete();
    
    ax.XLim = [1, dc.XSize];
    ax.YLim = [1, dc.YSize];
    
    % Set Title
    string = sprintf("%s: %s of [%.0f - %.0f]", ...
        dc.DisplayName, ...
        dc.Filter.Operation, ...
        dc.Filter.Range(1), ...
        dc.Filter.Range(2));
    ax.Title.String = string;
    
    imagesc(ax, output );
    
    
end

