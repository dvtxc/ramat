classdef DataContainer < handle
    %DATACONTAINER class
    %   This object class contains all data objects belonging to a single
    %   measurement. It can contain multiple Data Items (e.g. SpecData
    %   Instances)
    
    properties (Access = public)
        name;
%         xUnits;
%         xDataRaw;
%         yDataRaw;
%         nSpectra;
%         imageSize;
%         imageAxisScale;
        selected;
        Group;
    end
    
    properties (Access = public, Dependent)
        Data % This will always be the handle to the last/active data item in DataItems
        xData;
        yData;
        dataType;
    end
    
    properties (Access = public)
        DataItems = DataItem.empty;
    end
    
    properties (Access = private)
        ProjectParent;
    end
    
    methods
        function obj = DataContainer(name, xUnits, ...
                xData, xDataRaw, yData, yDataRaw, ...
                nSpectra, imageSize, imageAxisScale)
            %DATACONTAINER Construct an instance of this class
            
            if (nargin > 1)
                obj.name = name;
%                 obj.xUnits = xUnits;
%                 obj.xDataRaw = xDataRaw;
%                 obj.yDataRaw = yDataRaw;
%                 obj.nSpectra = nSpectra;
%                 obj.imageSize = imageSize;
%                 obj.imageAxisScale = imageAxisScale;
                
                obj.DataItems = SpecData('Spectrum', xData, yData);
            elseif (nargin == 1)
                obj.name = name;
                obj.DataItems = SpecData;
            else
                obj.name = 'empty';
                %obj.DataItems = SpecData; % empty SpecData instance
            end
            
            global CurrentProject
            
            if ~isempty(CurrentProject)
                obj.ProjectParent = CurrentProject;
            end
            
        end
        
        function h = get.Data(self)
            % Return handle for the last/active data item
            
            if numel(self.DataItems)    
                % Container contains data items, return last one
                h = self.DataItems(end);
            else
                % Container is empty, return empty DataItem instance
                h = DataItem.empty;
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
        
        function L = findgroup(self, group)
            %FINDGROUP returns handles of objects belonging to the provided
            %Group (Group object)
            
            L = DataContainer.empty;
            
            for i = 1:numel(self)
                if ~isempty(self(i).Group)
                    if (self(i).Group == group)
                        L = [L; self(i)];
                    end
                end
            end
            
        end
        
        function addSpecData(self, name, gdata, data, graph_unit, data_unit)
            %ADDSPECDATA
            %   Create new SpecData instance containing spectral data
            
            lastInstance = numel(self.DataItems);
            self.DataItems( lastInstance + 1 ) = SpecData(name, gdata, data, graph_unit, data_unit);
            
        end
        
        function appendSpecData(self, specdataobj)
            %APPENDSPECDATA
            %   Appends specdata object to list of data items
            
            lastInstance = numel(self.DataItems);
            self.DataItems( lastInstance + 1 ) = specdataobj; 
        end
        
   
                
        %% Getters and setters of Dependent Properties
        function ydat = get.yData(self)
            
            if (self.dataType == "SpecData")
                ydat = self.Data.YData;
            else
                ydat = [];
            end
        end

        function xdat = get.xData(self)
            
            if (self.dataType == "SpecData")
                xdat = self.Data.XData;
            else
                xdat = [];
            end
        end
        
        function dataType = get.dataType(self)
            if numel(self.DataItems)
                dataType = self.Data.Type;
            else
                dataType = "empty";
            end
        end
        
        function self = set.yData(self, ydata)
            lastInstance = numel(self.DataItems);
            self.DataItems(lastInstance).YData = ydata;
        end
        
        function self = set.xData(self, xdata)
            lastInstance = numel(self.DataItems);
            self.DataItems(lastInstance).XData = xdata;
        end
        
        %% Other methods
        function t = listDataItems(self)
            t = listItems(self.DataItems);
        end
        
        trimData(self, startx, endx, overwrite);
        
        normalizeData(self, overwrite);
        
        function idx = currentlySelectedDataItem(self)
            idx = numel(self.DataItems);
        end
        
    end
    
    methods (Hidden) %DEBUGGING
        function dbg(obj)
            keyboard
        end
    end
    
end

