function ax = plot(self, kwargs)
%PLOT Default plotting method, overloads default plot function.
%   This is the default method to plot data within the DataContainer. It
%   only takes the data container as necessary input argument, additional
%   keyword arguments provide plotting options and axis handles.
%
%   Examples:
%
%   PLOT(dc) plots data stored within the Data attribute against the values
%   stored in the Graph attribute in a new figure window. dc can either be
%   a single instance of DataContainer with dataType "SpecData" or
%   "ImageData", or it can be an array of DataContainers, whose dataType is
%   exclusively "SpecData".
%
%   PLOT(dc, Axes=ax) does the same as above, but uses the axes handle as
%   target.

    arguments
        self;                           % DataContainer
        kwargs.Axes = [];               % Axes Handle
        kwargs.Preview = false;         % When true, LAScan is reduced to one spectrum
        kwargs.GroupNames;              % Array of Group Names
        kwargs.GroupSizes;              % Num. of DataContainer instances per group
        kwargs.DataSizes;               % Redundant?
        kwargs.PlotType = "Overlaid";   % 'Overlaid', 'Stacked'
        kwargs.PlotStackDistance = 1;   % Stacking Shift Multiplier
        kwargs.Normalize = false;
        kwargs.PlotPeaks = true;
    end

    ax = [];
    
    if isempty(self)
        % Nothing has been selected
        return;
        
    end

    % Check if non-uniform data types have been selected
    if ~(all( vertcat( self.dataType ) == "SpecData" ) || (numel(self) == 1 && self.dataType == "ImageData" ))
        return;

    end
    
    % Get axes handle or create new figure window with empty axes
    if isempty(kwargs.Axes)
        f = figure;
        ax = axes('Parent',f);
    else
        if ( class(kwargs.Axes) == "matlab.graphics.axis.Axes" || class(kwargs.Axes) == "matlab.ui.control.UIAxes")
            ax = kwargs.Axes;

            % Get figure parent, might not be direct parent of axes
            f = ax;
            limit = 0;
            while (class(f) ~= "matlab.ui.Figure")
                f = f.Parent;
                limit = limit + 1;
                if limit > 10
                    throw(MException('Ramat:UI',"Could not find figure"))
                end
            end
            
            % Clear axes
            cla(ax, 'reset');
        else
            warning("Invalid Axes Handle");
            return;
            
        end
    end

    % Specify plot actions based on data type
    switch self(1).dataType
        case "SpecData"
            % Set-up Axes
            ax.PlotBoxAspectRatioMode = 'auto';
            ax.DataAspectRatioMode = 'auto';
            ax.XLimMode = 'auto';
            ax.YLimMode = 'auto';
            ax.YDir = 'normal';
            ax.XTickMode = 'auto';
            ax.YTick = [];

            ax.Color = 'none';

            % Set Labels
            ax.XLabel.String = 'Raman Shift [cm^-^1]';

            % Hold for multiple data
            hold(ax, 'on');
            
            % Calculate shift in case stacked data is plotted
            if kwargs.PlotType == "Stacked"
                % Stacked Plot
                multiplier = kwargs.PlotStackDistance;
                
                if kwargs.Normalize
                    stackShift = multiplier;
                else
                    % Apply multiplier to maximum value
                    stackShift = max(self) * multiplier;
                end
                
            else
                % Overlaid Plot
                stackShift = 0;
            end

            % PLOTTING
            for i = 1:numel(self)
                dat = self(i);

                xdat = dat.Graph;
                ydat = dat.DataPreview;
                
                % Normalize YData
                if kwargs.Normalize
                    ydat = ydat - min(ydat);
                    ydat = ydat ./ max(ydat);
                    
                end
                
                % Stacked Plot
                if kwargs.PlotType == "Stacked"
                    ydat = ydat - (i - 1)*stackShift;
                    
                end

                plot(ax, xdat, ydat);

                % Add peaks
                if kwargs.PlotPeaks
                    if any(vertcat(dat.DataItems.Type) == "PeakTable")
                        % There are peaktables
                        peaktable = dat.DataItems( find(vertcat(dat.DataItems.Type) == "PeakTable", 1, 'first' ) );
                        peaktable.plot(Axes=ax);
                    end
                end

            end

            % Add legend
            leg = legend(ax, vertcat(self.DisplayName));
            leg.Color = 'none';
            leg.Box = "off";

            % Release hold
            hold(ax, 'off');


        case "ImageData"
            % Plot first
            imagesc(ax, self.Data.Data );
            
            % Set-Up Axes
            ax.DataAspectRatio = [1 1 1];
            ax.XDir = 'normal';
            ax.YDir = 'normal';
            
%             ax.XTick = [];
%             ax.YTick = [];
%             ax.XAxis.Label.delete();
%             ax.YAxis.Label.delete();
% 
%             ax.XLim = [0.5, data.XSize + 0.5];
%             ax.YLim = [0.5, data.YSize + 0.5];


    end

    % Create cursor
    assign_spectral_cursor(f, ax);


end

