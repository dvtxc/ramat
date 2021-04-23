function updateScoresScatterPlot(app)
%UPDATESCORESSCATTERPLOT

    pcx = app.PCXSpinner.Value;
    pcy = app.PCYSpinner.Value;

    if ~isempty(app.prj.ActiveAnalysisResult)
        if (app.prj.ActiveAnalysisResult.dataType == "PCA")
            pcares = app.prj.ActiveAnalysisResult;
            ax = app.UIPreviewAxes;

            % Update preview
            pcares.scoresscatter([pcx pcy], ...
                Axes=ax, ...
                ErrorEllipse=app.PCAErrorEllipseCheckBox.Value);
        end

    end
end

