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
            self.name = name;
        end

        function t = get.Table(self)
            % TABLE Outputs peaks and locations as table

            t = table(self.locations, self.peaks);
            t.Properties.VariableNames = ["Wavenum", "Height"];
        end

    end



end
