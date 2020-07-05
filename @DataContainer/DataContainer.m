classdef DataContainer < handle
    %DATACONTAINER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        name;
        xUnits;
        xDataRaw;
        yDataRaw;
        nSpectra;
        imageSize;
        imageAxisScale;
        selected;
        group;
    end
    
    properties (Access = public, Dependent)
        xData;
        yData;
        dataType;
    end
    
    properties (Access = private)
        Data;
    end
    
    methods
        function obj = DataContainer(name, xUnits, ...
                xData, xDataRaw, yData, yDataRaw, ...
                nSpectra, imageSize, imageAxisScale)
            %DATACONTAINER Construct an instance of this class
            
            if (nargin > 1)
                obj.name = name;
                obj.xUnits = xUnits;
                obj.xDataRaw = xDataRaw;
                obj.yDataRaw = yDataRaw;
                obj.nSpectra = nSpectra;
                obj.imageSize = imageSize;
                obj.imageAxisScale = imageAxisScale;
                
                obj.Data = SpecData('Spectrum', xData, yData);
            elseif (nargin == 1)
                obj.name = name;
                obj.Data = SpecData;
            else
                obj.name = 'empty';
                obj.Data = SpecData; % empty SpecData instance
            end
            
        end
        
        function t = table(self)
            %TABLE Output data formatted as table
            %   This method overrides table() and replaces the need for
            %   struct2table()
            
            t = struct2table(struct(self));
            
        end
        
        function s = struct(self)
            %STRUCT Output data formatted as structure
            %   This method overrides struct()
            
            publicProperties = properties(self);
            s = struct();
            for i = 1:numel(self)
                for j = 1:numel(publicProperties)
                    s(i).(publicProperties{j}) = self(i).(publicProperties{j}); 
                end 
            end
            
        end
        
        function addSpecData(self, desc, xdata, ydata)
            %ADDSPECDATA
            %   Create new SpecData instance containing spectral data
            
            lastInstance = numel(self.Data);
            self.Data( lastInstance + 1 ) = SpecData(desc, xdata, ydata);
            
        end
        
        %% Getters and setters
        function ydat = get.yData(self)
            lastInstance = numel(self.Data);
            ydat = self.Data(lastInstance).YData;
        end
        
        function xdat = get.xData(self)
            lastInstance = numel(self.Data);
            xdat = self.Data(lastInstance).XData;
        end
        
        function dataType = get.dataType(self)
            lastInstance = numel(self.Data);
            dataType = self.Data(lastInstance).Type;
        end
        
        function self = set.yData(self, ydata)
            lastInstance = numel(self.Data);
            self.Data(lastInstance).YData = ydata;
        end
        
        function self = set.xData(self, xdata)
            lastInstance = numel(self.Data);
            self.Data(lastInstance).XData = xdata;
        end
        
        %% Other methods
        function t = listDataItems(self)
            t = listItems(self.Data);
        end
        
        trimData(self, startx, endx, overwrite);
        
        normalizeData(self, overwrite);
        
        function idx = currentlySelectedDataItem(self)
            idx = numel(self.Data);
        end
        
    end
    
    methods (Hidden) %DEBUGGING
        function dbg(obj)
            keyboard
        end
    end
    
end

