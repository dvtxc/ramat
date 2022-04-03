classdef PeakTable < DataItem
    % PEAKTABLE Stores extracted peak table

    properties
        peaks = [];
        locations = [];
        ParentSpecData;
        min_prominence = [];
    end

    properties (Dependent)
        Table;
    end

    % TO-DO remove these dependent properties,
    % needed for verbose table output
    properties (Dependent)
        XSize;
        YSize;
        ZSize;
        DataSize;
    end

    properties (SetAccess = private)
        Type = "PeakTable";
    end

    % Method signatures
    methods
        plot(self, options)
    end

    methods
        function self = PeakTable(peaks, locations, parent_specdata, name)
            % PEAKTABLE Construct an instance of this class

            arguments
                peaks (:,1) {mustBeNumeric,mustBeReal};
                locations (:,1) {mustBeNumeric,mustBeReal,mustBeEqualSize(peaks,locations)};
                parent_specdata SpecData = [];
                name string = "";
            end

            self.peaks = peaks;
            self.locations = locations;
            self.ParentSpecData = parent_specdata;
            self.Name = name;
        end

        function t = get.Table(self)
            % TABLE Outputs peaks and locations as table

            t = table(self.locations, self.peaks);
            t.Properties.VariableNames = ["Wavenum", "Height"];
        end

    end

    % Dependent
    methods
        %% Dependent Properties
        function xres = get.XSize(self)
            xres = 0;
        end  
        function yres = get.YSize(self)
            yres = 0;
        end  
        function zres = get.ZSize(self)
            zres = 0;
        end 
        function datares = get.DataSize(self)
            datares = 0;
        end



    end

end
