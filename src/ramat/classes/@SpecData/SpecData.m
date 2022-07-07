classdef SpecData < DataItem
    %SPECDATA Class to contain spectral (Raman) data
    %   This class contains spectral and meta data of a single measurement.
    
    properties      
        % Spectral Data
        Data double;      % 3D array (size: m*n*o), spectral data (i,j,k)
        DataUnit string;  % Data unit, usually: "cts." or "a.u."
        
        % Spectral Base
        Graph double;     % 1D array (size: o), spectral base vector (k)
        GraphUnit string; % Spectral base units, usually: "cm-1"
        
        % Info
        ExcitationWavelength;
        
        % Spatial Grid Data
        X;
        Y;
        Z;
        XLength;
        YLength;
        ZLength;

        % Cursor for large area spectra
        cursor Cursor;

        % Mask
        Mask Mask = Mask().empty;

        % PeakTable
        PeakTable PeakTable = PeakTable.empty();
    end
    
    properties (Access = public, Dependent)
        FilteredData;
        FlatDataArray;
        GraphSize;
        XSize;
        YSize;
        ZSize;
        DataSize;       % Size of first two dimensions of Data (m*n)
        
        XData; % Deprecated
        YData; % Deprecated
    end
    
    properties (SetAccess = private)
        Type = "SpecData";
    end

    % Signatures
    methods
        removeBaseline(self, method, kwargs);
        peak_table = extract_peak_table(self, options);
        peak_table = find_peaks(self, options);
    end
    
    methods
        function obj = SpecData(name, graphbase, data, graphunit, dataunit)
            %SPECDATA Construct an instance of this class
            %   Stores x-data and y-data

            arguments
                name string = "";
                graphbase = [];
                data = [];
                graphunit = "";
                dataunit = "";
            end

            % Store properties
            obj.Name = name;
            obj.Graph = graphbase;
            obj.Data = data;
            obj.GraphUnit = graphunit;
            obj.DataUnit = dataunit;
            
            % Create LA scan cursor
            obj.cursor = Cursor(obj);

        end
        
        out = clipByMask(self, mask);
        
        function normalizeSpectrum(self)
            % Normalizes spectrum, so sum(Data) = 1
            
            % Repeat operation for each spectral data object
            for i = 1:numel(self)                
                % Convert to double
                dat = double(self(i).Data);
                
                % Divide by sums of the individual spectra
                self(i).Data = dat ./ sum( dat, 3 );
            end
        end
        
        function obj = removeConstantOffset(obj)
            % Removes a constant offset (minimum value)
            
            % Repeat operation for each spectral data object
            for i = 1:numel(obj)
                dat = obj(i).Data;
                graph_resolution = obj(i).GraphSize;
                
                min_values = min(dat, [], 3);
                subtractionMatrix = repmat(min_values, 1, 1, graph_resolution);
                
                obj(i).Data = dat - subtractionMatrix;
            end
        end
        
        function idx = wavnumtoidx(self, wavnum)
            % WAVNUMTOIDX Convert wavenumbers to indices
            
            if numel(wavnum) == 1
                idx = find(self.Graph > wavnum, 1, 'first');
            elseif numel(wavnum) == 2
                startIdx = find(self.Graph > wavnum(1), 1, 'first');
                endIdx = find(self.Graph < wavnum(2), 1, 'last');
                
                idx = [startIdx, endIdx];
            end
            
        end

        function spec = get_single_spectrum(self)
            %GET_SINGLE_SPECTRUM Retrieves single spectrum at cursor or
            %accumulated over the size of the cursor

            % Check if single spectrum to reduce computational time
            if (self.DataSize == 1)
                spec = self.Data(1, 1, :);
                spec = permute(spec, [3 1 2]);
                return;
            end

            % Do rest for large area scans

            % Check for cursor
            if isempty(self.cursor)
                % Spectral Data does not have cursor. Create one.
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
        function self = set.Data(self, data)
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
        
        % Deprecated, still here for backwards compatibility
        function ydatflat = get.YData(self)
            ydatflat = self.FlatDataArray;
        end
        
        function xdat = get.XData(self)
            xdat = self.Graph;
        end
        
        function self = set.YData(self, ydata)
            self.Data = ydata;
        end
        
        function self = set.XData(self, xdata)
            self.Graph = xdata;
        end

        %% Overrides

       
        
    end
end

