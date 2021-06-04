classdef SpecData < DataItem
    %SPECDATA Instance containing spectral data
    %   Detailed explanation goes here
    
    properties      
        % Spectral Data
        Data;
        DataUnit;
        
        % Spectral Base
        Graph;
        GraphUnit;
        
        % Info
        ExcitationWavelength;
        
        % Spatial Grid Data
        X;
        Y;
        Z;
        XLength;
        YLength;
        ZLength;
    end
    
    properties (Access = public, Dependent)
        FlatDataArray;
        GraphSize;
        XSize;
        YSize;
        ZSize;
        DataSize;
        
        XData; % Deprecated
        YData; % Deprecated
    end
    
    properties (SetAccess = private)
        Type = "SpecData";
    end
    
    methods
        function obj = SpecData(name, graphbase, data, graphunit, dataunit)
            %SPECDATA Construct an instance of this class
            %   Stores x-data and y-data
            
            if (nargin == 0)
                % Create empty spectral data object
                obj.Name = "empty";
                obj.Graph = [];
                obj.Data = [];
            elseif (nargin >= 3)
                obj.Name = name;
                obj.Graph = graphbase; % Spectral x-axis
                obj.Data = data;
                
                if nargin >= 4
                    if ~isempty(graphunit)
                        obj.GraphUnit = graphunit;
                    end
                end
                
                if nargin >= 5
                    if ~isempty(dataunit)
                        obj.DataUnit = dataunit;
                    end
                end
                
                % Deprecated;
                obj.XData = graphbase;
                obj.YData = data;
            end

        end
        
        clipByMask(self, mask);
        
        function obj = normalizeSpectrum(obj)
            % Normalizes spectrum, so sum(Data) = 1
            
            % Repeat operation for each spectral data object
            for i = 1:numel(obj)                
                % Convert to double
                dat = double(obj(i).Data);
                
                % Divide by sums of the individual spectra
                obj(i).Data = dat ./ sum( dat, 3 );
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
        
        
        %% Setter
        function self = set.Data(self, data)
            % Force a three-dimensional matrix
            if numel(size(data)) == 3
                self.Data = data;
            else
                self.Data = permute(reshape(data', self.XSize, self.YSize, self.GraphSize), [2 1 3]);
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
        
    end
end

