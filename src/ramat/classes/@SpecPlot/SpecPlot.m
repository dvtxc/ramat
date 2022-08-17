classdef SpecPlot
    %SPECPLOT Saved spectral plot
    %   ...
    
    properties
        name string;
        parent Project;
        data AnalysisGroup;
        options = struct();
        selection;
    end
    
    properties
        dataType = "SpecPlot";
    end
    
    methods
        function self = SpecPlot(data, parent, kwargs)
            %SPECPLOT Construct an instance of this class
            %   ...
            
            arguments
                data {mustBeA(data, ["DataContainer", "Link"])};
                parent Project;
                kwargs.plot_type = 'Overlaid';
            end

            self.data = AnalysisGroup(Analysis.empty(), "Plotting");
            self.data.append_data(data);

            self.parent = parent;
            
            self.options.plot_type = kwargs.plot_type;
            self.options.plot_stack_distance = 1;
            
        end

        function [ax, f] = plot(self, options)

            arguments
                self SpecPlot;
                options.Axes = [];
            end

            static_data = self.data.get_static_list();

            static_data.plot( ...
                Axes=options.Axes, ...
                plot_type=self.options.plot_type, ...
                plot_stack_distance=self.options.plot_stack_distance);

        end
        
    end
end

