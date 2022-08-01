classdef SpectrumSimple < SpecDataABC
    %SPECTRUMSIMPLE Simple spectral class.
    %   This class contains simple spectral data (X and Y data) for direct
    %   plotting and peak analysis. This class can be used for plotting
    %   data. This class can NOT store spatial data.
    %
    %   Parent Class: SpecDataABC
    %
    %   Properties inherited from parent class "DataItem":
    %       name        string
    %       description string
    %       parent      DataContainer
    %       Type        string
    %
    %   Properties inherited from parent class "SpecDataABC":
    %       data        double  (abstract)
    %       data_unit   string
    %       graph       double (1xm)
    %       graph_unit  string
    %       peak_table  PeakTable

    properties (Access = public)
        data double;
        source SpecData;
        legend_entries string;
    end

    methods
        function self = SpectrumSimple(xdata, xdata_unit, ydata, ydata_unit, source)
            %SPECTRUMSIMPLE Creates an instance of a simple spectral class

            arguments
                xdata double = [];
                xdata_unit string = "";
                ydata double = [];
                ydata_unit string = "";
                source {mustBeA(source, ["SpecData", "PCAResult"])} = [];
            end

            self.graph = xdata;
            self.graph_unit = xdata_unit;
            self.data = ydata;
            self.data_unit = ydata_unit;
            self.source = source;

        end
    end
    
end