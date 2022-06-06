classdef SpectralCursor < handle
    %SPECTRALCURSOR Cursor for spectral data graphs
    %   Detailed explanation goes here
    
    properties
        cursor struct = [];
        axes = [];
    end
    
    methods
        function self = SpectralCursor(f, ax)
            %SPECTRALCURSOR Construct an instance of this class
            %   Construct cursor and create and assign callback to figure
            
            arguments
                f matlab.ui.Figure = [];
                ax = []; % must be either matlab.ui.control.UIAxes or matlab.graphics.axis.Axes
            end

            self.axes = ax;

            % Create cursor
            self.draw();

            % Assign callback to window
            f.WindowButtonMotionFcn = @(~,~) self.redraw();
        end

        function draw(self)
            %DRAW Draw cursor for the first time

            self.cursor = [];

            % Freeze axes
            hold(self.axes,"on");
            xlim(self.axes, self.axes.XLim);
            ylim(self.axes, self.axes.YLim);
            self.axes.Legend.AutoUpdate = 'off';

            self.cursor(1).h = line(self.axes, [0 0], self.axes.YLim);
            self.cursor(2).h = line(self.axes, self.axes.XLim, [0 0]);
            self.cursor(3).h = text(self.axes, 0, 0, "");

        end
        
        function redraw(self)
            %REDRAW Redraw cursor in axes

            % Check if deleted
            if ~isgraphics(self.axes)
                warning("Axes have been deleted.");
                return;
            end

            % Check if cursor exists
            if isempty(self.cursor)
                self.draw();
            end

            if ~any(isgraphics([self.cursor.h]))
                self.draw();
            end

            x = self.axes.CurrentPoint(1,1);
            y = self.axes.CurrentPoint(1,2);
        
            self.cursor(1).h.XData = [x x];
            self.cursor(2).h.YData = [y y];
            self.cursor(3).h.Position = [x y 0];
            self.cursor(3).h.String = sprintf("x: %.2f cm^-^1\ny: %.3f a.u.", x, y);
        end
    end
end

