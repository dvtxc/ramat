classdef DataContainer < handle
    %DATACONTAINER class
    %   This object class contains all data objects belonging to a single
    %   measurement. It can contain multiple Data Items (e.g. SpecData
    %   Instances)
    
    properties (Access = public)
        Name;
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
        
        XSize;
        YSize;
        
        AnalysisGroupParent = AnalysisGroup.empty;
        
        DisplayName;
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
                obj.Name = name;
%                 obj.xUnits = xUnits;
%                 obj.xDataRaw = xDataRaw;
%                 obj.yDataRaw = yDataRaw;
%                 obj.nSpectra = nSpectra;
%                 obj.imageSize = imageSize;
%                 obj.imageAxisScale = imageAxisScale;
                
                obj.DataItems = SpecData('Spectrum', xData, yData);
            elseif (nargin == 1)
                obj.Name = name;
                obj.DataItems = SpecData;
            else
                obj.Name = "";
                %obj.DataItems = SpecData; % empty SpecData instance
            end
            
            global prj
            
            if ~isempty(prj)
                obj.ProjectParent = prj;
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
                    if strcmp(publicProperties{j}, 'Group') && ~isempty(self(i).Group)
                        s(i).(publicProperties{j}) = self(i).(publicProperties{j}).Name;
                    else
                        s(i).(publicProperties{j}) = self(i).(publicProperties{j}); 
                    end
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
        
        function setgroup(self, group)
            %SETGROUP
            %   Set group for the DataContainers
            %   self:   nx1 DataContainer
            %   group:  1x1 Group
            
            % Only one group can be assigned
            if numel(group) > 1
                group = group(1);
            end
            
            % Assign group to each instance of DataContainer
            for i = 1:numel(self)
                self(i).Group = group;
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
            %   It can also append multiple SpecData objects to multiple
            %   DataContainer objects if the number of instances is equal.
            
            numSpecDataObj = numel(specdataobj);
            numSelf = numel(self);
            
            if ~(numSpecDataObj == 1 || numSpecDataObj == numSelf)
                % The number of SpecData objects cannot be unambigeously
                % appended to the corresponding DataContainer instances.
                
                return
            end
            
            if numSpecDataObj == 1
                newSpecData = specdataobj;
            end
            
            for i = 1 : numSelf
                % For every instance of DataContainer
                
                if (numSpecDataObj > 1)
                    newSpecData = specdataobj(i);
                end
                
                lastInstance = numel(self(i).DataItems);
                self(i).DataItems( lastInstance + 1 ) = newSpecData;
            end
        end
        
        function duplicateData(self, datatype)
            
            if nargin > 1
                h = self.getDataHandles(datatype);
            else
                h = self.getDataHandles();
            end
                
            duplicates = copy(h);
            
            self.appendSpecData( duplicates );
            
            
        end
        
        function pcaresult = grouped_pca(self)
            %GROUPED_PCA
            %   Groups Data Containes, Sorts by group, calculates PCA
            
            % Filter for SpecDat
            set = findobj(self, 'dataType', "SpecData");
            
            
            % Find unique groups and sort by group
            group_arr = vertcat(set.Group);
            group_name = transpose({group_arr.Name});
            [~, ~, group_num] = unique(group_arr);
%             num_spectra = transpose([set.XSize] .* [set.YSize]);
            data = vertcat(set.Data);
            
            % NaNs are not included in PCA and should, therefore, be left
            % out of the calculation of the number of spectra
            num_spectra = zeros( numel(set), 1 );
            for i = 1 : numel(set)
                num_spectra(i) = sum( ~any( isnan( set(i).Data.FlatDataArray) ) );
            end
                        
            T = table(group_num, group_name, num_spectra, data);
            T = sortrows(T, 'group_num');
            
            % Create summary table
            num_spectra = accumarray(T.group_num, T.num_spectra);
            group_name = unique(T.group_name);
            G = table( group_name, num_spectra );
            
            % Perform PCA
            pcaresult = data.calculatePCA();
            
            % Append Groups
            pcaresult.Groups = G;
            
        end
        
        function h = getDataHandles(self, data_type)
            %% Get handles of spectral data objects
            
            if nargin > 1
                try
                    set = findobj(self, 'dataType', data_type);
                    h = vertcat(set.Data);
                catch
                    warning('Could not find suitable data.');
                    h = [];
                end
            else
                % Get all handles of DataItem() child classes within the
                % DataContainer() instances.
                h = vertcat(self.Data);
            end
            
        end
        
        function set.Name(self, newname)
            self.Name = newname;
        end
   
                
        %% Getters and setters of Dependent Properties
        function displayname = get.DisplayName(self)
            %DISPLAYNAME Format name nicely
            
            if (self.Name == "")
                displayname = "No Name";
            else
                displayname = self.Name;
            end
        end
        
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
        
        function set.yData(self, ydata)
            lastInstance = numel(self.DataItems);
            self.DataItems(lastInstance).YData = ydata;
        end
        
        function set.xData(self, xdata)
            lastInstance = numel(self.DataItems);
            self.DataItems(lastInstance).XData = xdata;
        end
        
        function xsize = get.XSize(self)
            if numel(self.DataItems)
                xsize = self.Data.XSize;
            else
                xsize = [];
            end
        end
        
        function ysize = get.YSize(self)
            if numel(self.DataItems)
                ysize = self.Data.YSize;
            else
                ysize = [];
            end
        end
        
        function analysisGroupParent = get.AnalysisGroupParent(self)
            % TO DO: return the parent group
            
            analysisGroupParent = AnalysisGroup.empty;
            
            for i = 1 : numel(prj.AnalysisSet)
                subset = prj.AnalysisSet(i);
                
                for j = 1:numel(subset.GroupSet)
                    subsetgroup = subset.GroupSet(j);
                end
            end
        end
        
        %% Destructor
        
        function delete(self)
            %DESTRUCTOR Delete all references to object
            
%             for i = 1:numel(self)
%                 % For every instance
%                 ds = self.ProjectParent.DataSet;
%                 
%             end
        end
        
        %% Other methods
        function t = listDataItems(self)
            t = listItems(self.DataItems);
        end
        
        trimData(self, startx, endx, overwrite);
        
        normalizeData(self, overwrite);
        
        subsetHandle = addToNewSubset(self);
        
        addToSubset(self, subsetHandle);
        
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

