classdef SpecData < SpecDataABC
    %SPECDATA Full spectral data class
    %   This class stores spectral data, including spatial information.
    %   This class will generate a simple spectrum "SpectrumSimple" class
    %   for plotting purposes.
    %
    %   Parent Class: SpecDataABC < DataItem
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
        % Spectral Data
        data double;

        % Meta
        excitation_wavelength double;
        
        % Spatial Grid Data
        x double;
        y double;
        z double;
        xlength double;
        ylength double;
        zlength double;

        % Cursor for large area spectra
        cursor cursor;

        % Mask
        mask Mask;
    end

    properties (Access = public, Dependent)
        FilteredData;
        FlatDataArray;
        GraphSize;
        XSize;
        YSize;
        ZSize;
        DataSize;
    end

    % Signatures
    methods
        removeBaseline(self, method, kwargs);
        out = clipByMask(self, mask);
    end
    
    methods
        function self = SpecData(name, graphbase, data, graphunit, dataunit)
            %SPECDATA Construct an instance of this class
            %   Stores x-data and y-data

            arguments
                name string = "";
                graphbase double = [];
                data {mustBeA(data, ["double", "single"])} = [];
                graphunit string = "";
                dataunit string = "";
            end

            % Convert data to double
            if class(data) == "single"
                data = double(data);
            end

            % Store input args as properties
            self.name = name;
            self.graph = graphbase;
            self.graph_unit = graphunit;
            self.data = data;
            self.data_unit = dataunit;

            % Create LA scan cursor
            self.cursor = Cursor(self);

        end
        
        
        function normalize_spectrum(self)
            % Normalizes spectrum, so sum(Data) = 1
            
            % Repeat operation for each spectral data object
            for i = 1:numel(self)               
                % Divide by sums of the individual spectra
                self(i).data = dat ./ sum( dat, 3 );
            end
        end
        function normalizeSpectrum(self)
            warning("Rename SpecData.normalizeSpectrum()");
            self.normalize_spectrum();
        end
                
        function remove_constant_offset(self)
            % Removes a constant offset (minimum value)
            
            % Repeat operation for each spectral data object
            for i = 1:numel(self)
                dat = self(i).data;
                graph_resolution = self(i).GraphSize;
                
                min_values = min(dat, [], 3);
                subtractionMatrix = repmat(min_values, 1, 1, graph_resolution);
                
                self(i).data = dat - subtractionMatrix;
            end
        end
        function removeConstantOffset(self)
            warning("Rename SpecData.removeConstantOffset()");
            self.remove_constant_offset();
        end
        

        function spec_simple = get_spectrum_simple(self)
            %GET_SPECTRUM_SIMPLE Get simple spectrum class, wrapper
            % function of GET_SINGLE_SPECTRUM.

            spec_simple = SpectrumSimple( ...
                self.graph, ...                     % xdata
                self.graph_unit, ...                % xdata_unit
                self.get_single_spectrum(), ...     % ydata
                self.data_unit, ...                 % ydata_unit
                self);                              % source

        end

        function spec = get_single_spectrum(self)
            %GET_SINGLE_SPECTRUM Retrieves single spectrum at cursor or
            %accumulated over the size of the cursor

            if (self.DataSize == 1)
                spec = self.Data(1, 1, :);
                spec = permute(spec, [3 1 2]);
                return;
            end

            if isempty(self.cursor)
                self.cursor = Cursor(self);
            end

            if (self.cursor.size == 1)
                spec = self.Data(self.cursor.x, self.cursor.y, :);

            else
                % Accumulate over cursor
                
                rows = self.cursor.mask_coords.rows;
                cols = self.cursor.mask_coords.cols;
                spec = mean(self.Data(rows(1):rows(2), cols(1):cols(2), :),[1 2]);

            end

            % Return 1-dimensional array
            spec = permute(spec, [3 1 2]);

        end

        %% Overrides

        function avg_specdat = mean(self)
            % MEAN Returns averaged spectral data

            arguments
                self
            end

            % Can only do for similarly sizes specdats
            assert(range(vertcat(self.GraphSize)) == 0, "Not all SpecData instances are equal in size.");
            assert(range(vertcat(self.XSize)) == 0, "Not all SpecData instances are equal in size.");
            assert(range(vertcat(self.YSize)) == 0, "Not all SpecData instances are equal in size.");

            % Calculate average
            avg_dat = mean(cat(4, self.Data), 4);

            % Create SpecDat
            newname = sprintf("Average of %d", numel(self));
            avg_specdat = SpecData(newname, self(1).Graph, avg_dat, self(1).GraphUnit, self(1).DataUnit);
    
        end
        
        % DEPENDENT PROPERTIES
        function wavres = get.GraphSize(self)
            % Returns size or wave resolution of the spectral graph
            wavres = size(self.Graph, 1);
        end
        
        function xres = get.XSize(self)
            xres = size(self.Data, 1);
        end
        
        function yres = get.YSize(self)
            yres = size(self.Data, 2);
        end
        
        function zres = get.ZSize(self)
            % TO BE IMPLEMENTED
            zres = 0;
        end
        
        function datares = get.DataSize(self)
            datares = self.XSize * self.YSize;
        end
        
        function flatdata = get.FlatDataArray(self)
            % Returns a two-dimensional m-by-n array of spectral data
            graphsize = size(self.Data, 3);
            
            flatdata = permute(self.Data, [3 1 2]);
            flatdata = reshape(flatdata, graphsize, [], 1);
        end

        function filtereddata = get.FilteredData(self)
            % Returns filtered and masked data

            filtereddata = clipByMask(self, self.Mask, Clip=false);

        end
        
        
        %% Setter
        function set.data(self, data)
            % Force a three-dimensional matrix
            if numel(size(data)) == 3
                self.Data = data;
            else
                if isempty(self.Data)
                    xs = 1;
                    ys = 1;
                else
                    xs = self.XSize;
                    ys = self.YSize;
                end
                self.Data = permute(reshape(data', xs, ys, self.GraphSize), [2 1 3]);
            end
        end
        

        
    end
end

