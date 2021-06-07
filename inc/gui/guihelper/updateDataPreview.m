function updateDataPreview(app, data)
%UPDATEDATAPREVIEW Update the preview pane
            
    if isempty(data)
        % Nothing has been selected

        return;
    end
    
    if ~(all( vertcat( data.dataType ) == "SpecData" ) || (numel(data) == 1 && data.dataType == "ImageData" ))
        % Non-uniform data types have been selected

        return;

    end
    

    % Get axes handles
    ax = app.UIPreviewAxes;
    cla(ax);
    
    switch data(1).dataType
        case "SpecData"
            % Set-up Axes
            ax.PlotBoxAspectRatioMode = 'auto';
            ax.DataAspectRatioMode = 'auto';
            ax.CameraUpVector = [0 1 0];
            ax.XLabel.String = 'Raman Shift [cm^-^1]';
            ax.XLimMode = 'auto';
            ax.YLimMode = 'auto';
            ax.YDir = 'normal';
            ax.XTickMode = 'auto';
            ax.YTick = [];

            % Hold for multiple data
            hold(ax, 'on');

            for i = 1:numel(data)
                dat = data(i);

                xdat = dat.Graph;
                ydat = dat.DataPreview;

                plot(ax, xdat, ydat);
            end

            % Release hold
            hold(ax, 'off');
            
        case "ImageData"
            % Set-Up Axes
            ax.DataAspectRatio = [1 1 1];
            ax.PlotBoxAspectRatioMode = 'auto';
            
            ax.XTick = [];
            ax.YTick = [];
            ax.XAxis.Label.delete();
            ax.YAxis.Label.delete();
            
            ax.CameraUpVector = [0 1 0];

            ax.XLim = [1, data.XSize];
            ax.YLim = [1, data.YSize];
            
            imagesc(ax, data.Data.Data );
end


