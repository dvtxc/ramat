function plot(self, options)
    %PLOT Plots peaks with annotations, overloads default plot function.
    %   This is the default method to plot the peaks contained in the
    %   PeakTable. It only takes the PeakTable as necessary input argument,
    %   additional keyword arguments provide plotting options and axis
    %   handles.
    %
    %   Examples:
    %   
    %   PLOT(peaktable, Axes=ax)

    arguments
        self PeakTable;
        options.Axes = [];
        options.Precision {mustBeReal,mustBeNumeric} = 0;     % number of digits right of decimal
    end

    if isempty(self) || ~isvalid(self)
        % Nothing has been selected or handle of deleted object.
        return
    end

    % Get axes handle or create new figure window with empty axes
    if isempty(options.Axes)
        f = figure;
        ax = axes('Parent',f);
    else
        if ( class(options.Axes) == "matlab.graphics.axis.Axes" || class(options.Axes) == "matlab.ui.control.UIAxes")
            ax = options.Axes;
            
        else
            warning("Invalid Axes Handle");
            return;
            
        end
    end

    % Hold axes, so peaks are added to existing plot
    hold(ax, "on");

    % Add annotation
    for i = 1:length(self.peaks)
        % Create "tuple"-like var with location and y-pos.
        peak = [self.locations(i), self.peaks(i)];

        % Create string for annotation
        annotation_string = sprintf("%.*f", options.Precision, peak(1));
        annotation_marker = {annotation_string; "|"; ""; ""; ""};
        
        % Add annotation to plot
        t = text(ax, peak(1), peak(2), annotation_marker);
        t.HorizontalAlignment = 'center';
        t.FontWeight = 'bold';
    end

end