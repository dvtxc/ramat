function updateSpecAreaFilterOutput(app)
%UPDATESPECAREAFILTEROUTPUT 
    ax = app.UIAxes;
    filter = app.Filter;
    specdat = app.DataCon.Data;
    
    % Set-Up Axes
    ax.XTick = [];
    ax.YTick = [];
    ax.XAxis.Label.delete();
    ax.YAxis.Label.delete();
    
    ax.XLim = [1, specdat.XSize];
    ax.YLim = [1, specdat.YSize];
    
    imagesc(ax, filter.getResult( specdat ));
    
    
end

