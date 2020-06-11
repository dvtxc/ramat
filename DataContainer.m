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
        
        function trimData(self, startx, endx, overwrite)
        %TRIMDATA Trim spectral data
        %   Checks whether the container has spectral data
        %   Trims data to [start wavenumber] till [end wavenumber]
        
            for i = 1:numel(self)
                if (self(i).dataType == "SpecData")
                    % Select last data item
                    didx = numel(self(i).Data);
                    
                    try
                        trimmedDataObj = trimSpectrum(self(i).Data(didx), startx, endx);
                        
                        if (overwrite == true)
                            self(i).Data(didx) = trimmedDataObj;
                        else
                            newDescription = sprintf("Trim [%i - %i]", startx, endx);
                            self(i).addSpecData(newDescription, trimmedDataObj.XData, trimmedDataObj.YData);
                        end
                        
                    catch
                        warning('Could not trim spectral data.');
                    end
                end
            end
            
        end
        
        function normalizeData(self, overwrite)
        %NORMALIZEDATA Normalize spectral data
        %   Checks whether the container has spectral data
        %   Normalizes data, so sum = 1
        
            for i = 1:numel(self)
                if (self(i).dataType == "SpecData")
                    %Select last data item
                    didx = numel(self(i).Data);
                    
                    try
                        normalizedDataObj = normalizeSpectrum(self(i).Data(didx));
                        
                        if (overwrite == true)
                            self(i).Data(didx) = normalizedDataObj;
                        else
                            newDescription = "Normalize";
                            self(i).addSpecData(newDescription, normalizedDataObj.XData, normalizedDataObj.YData);
                        end
                        
                    catch
                        warning('Could not normalize spectral data.');
                    end
                    
                end
            end
        end
        
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

