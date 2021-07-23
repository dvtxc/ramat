classdef SpecPlot < AnalysisResult
    %SPECPLOT Saved spectral plot
    %   ...
    
    properties
        Data;
        GroupNames;
        GroupSizes;
        DataSizes;
        PlotOptions = struct();
    end
    
    properties
        dataType = "SpecPlot";
    end
    
    methods
        function self = SpecPlot(data, kwargs)
            %SPECPLOT Construct an instance of this class
            %   ...
            
            arguments
                data;
                kwargs.GroupNames;
                kwargs.GroupSizes;
                kwargs.DataSizes;
                kwargs.PlotType = 'Overlaid';
            end
            
            self.Data = data;
            
            self.PlotOptions.PlotType = kwargs.PlotType;
            self.PlotOptions.PlotStackDistance = 1;
            
        end
        
    end
end

