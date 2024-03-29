classdef Analysis < handle
    %ANALYSIS Analysis subset used for PCA Analysis
    %   Detailed explanation goes here
    
    properties (Access = public)
%         DataSet = DataContainer.empty;
        GroupSet = AnalysisGroup.empty;
        Parent = Project.empty;
        Selection = DataContainer.empty;
        Name = "";
    end
    
    properties (Access = public, Dependent)
        DisplayName;
        DataSet; % Set of all DataContainers
    end
    
    methods
        function self = Analysis(parentProject, dataset)
            %CONSTRUCTOR
            self.Parent = parentProject;
            
            self.append_data(dataset);
        end
        
        function append_data(self, dataset, new_group_name)
            arguments
                self;
                dataset;
                new_group_name string = "";
            end
            
            newgroup = self.add_group(new_group_name);
            newgroup.append_data(dataset);
            
        end
                
        function set_name(self, name)
            self.Name = name;
        end
        
        function displayname = get.DisplayName(self)
            % Get formatted DisplayName
            if (self.Name == "")
                displayname = "Empty Subset";
            else
                displayname = self.Name;
            end
        end
        
        function newgroup = add_group(varargin)
            %ADD_GROUP Add analysis group to current analysis subset
            
            self = varargin{1};
            
            if (nargin == 1)
                % Construct new analysis group without name
                
                newgroup = AnalysisGroup(self);
                
            elseif (nargin == 2)
                % Construct new analysis group with name
                
                name = varargin{2};
                newgroup = AnalysisGroup(self, name);
                
            end
            
            % Add new group to group set.
            self.GroupSet = [self.GroupSet; newgroup];
            
        end
        
        function move_data_to_group(self, dataset, newgroup)
            %MOVE_DATA_TO_GROUP Moves data to an analysis group by
            %DataContainer handle
            %   This function will move ALL instances of the DataContainer
            %   to a single group.
            
            for i = 1:numel(dataset)
                % For every datacontainer that has to be moved
                
                datacon = dataset(i);
                
                % Step 1: Remove data from old group(s)
                                
                % Remove occurences of the datacontainer in unassigned
                % dataset.
%                 self.DataSet(self.DataSet == datacon) = [];
                
                % Check all the groups
                for g = 1:numel(self.GroupSet)
                    % Find occurences of the datacontainer in this group's
                    % children and remove the occurences
                    
                    group = self.GroupSet(g);
                    group.Children(datacon == group.Children) = [];
                    
                end
                
                % Step 2: Assign data to new group
                newgroup.append_data(datacon);
            end
            
        end
        
        function dataset = get.DataSet(self)
            %DATASET Ungrouped list of datacontainers of this analysis
            %subset.
            
            dataset = DataContainer.empty;
            
            for i = 1:numel(self.GroupSet)
                % Look for data in each group
                
                group = self.GroupSet(i);
                
                for j = 1:numel(group.Children)
                    dc = group.Children(j);
                    
                    dataset = [dataset; dc];
                    
                end
            end
            
        end
        
        function plot(self, options)
            %PLOT
            
            arguments
                self
                options.Selection = self.DataSet;
            end
            
            data = options.Selection;
            
            [sortedData, groupNames, groupSizes, dataSizes] = self.sortdata(Selection=data);
            
            SpectralPlotEditor(sortedData, ...
                GroupNames=groupNames, ...
                GroupSizes=groupSizes, ...
                DataSizes=dataSizes);
            
        end
        
        function pcaresult = compute_pca(self, options)
            %COMPUTE_PCA Compute a principle component analysis (PCA) of
            %current analysis subset.
            %TODO: pass source data as analysis groups!!
            %Input:
            %   self
            %   options.Range:      range [2x1 array] in cm^-1
            %   options.Selection   selection of DataContainers
            %
            %Output:
            %   pcaresult:  PCAResult object
            
            arguments
                self Analysis
                options.Range
                options.Selection (:,:) DataContainer = DataContainer.empty;
            end
            
            pcaresult = PCAResult.empty;
                        
            % Get handles of selected data containers
            if isempty(options.Selection)
                % No selection has been provided, take self.Selection
                data = self.Selection;
                
            else
                % Selection has been provided
                
                % Make sure the selection corresponds to data that is
                % within this analysis subset
                % TO-DO
                
                data = options.Selection;
                
            end
                        
            if ~isempty(data)
                
                % Get list of groups
                grouplist = self.getParentGroups(data, ExclusiveDataType="SpecData");
                
                % Get spectral data handles from selected containers
                specdata = data.getDataHandles('SpecData');
                
                % Check whether we have group information for all data
                if (numel(grouplist) ~= numel(specdata))
                    warning("Data selection for PCA failed.");
                    return
                end
                                
                % Sort data by group
                [groups, ~, groupIdx] = unique(grouplist);
                [sortedGroupIdx, sortingIdx] = sort(groupIdx);
                
                specdata = specdata(sortingIdx);
                
                groupNames = vertcat( groups.DisplayName );
                
                % Get data sizes
                dataSizes = vertcat( specdata.DataSize );
                groupSizes = accumarray( sortedGroupIdx, dataSizes);

                if ~isempty(specdata)
                    % Selection contains actual spectral data

                    if isempty(options.Range)
                        % No range has been provided, take entire range

                        pcaresult = specdata.calculatePCA();
                    else
                        % Take only provided range

                        pcaresult = specdata.calculatePCA(options.Range);
                        
                    end
                else
                    % No spectral data
                    warning("No spectral data has been selected");
                    
                end
                
                % Add source data information to PCA result
                % TODO: perhaps implement AnalysisGroup()?
                groupChildren = cell(numel(groupSizes),1);
                jidx = 1;
                for i = 1:numel(groupSizes)
                    groupChildren{i} = vertcat( specdata(jidx : jidx + groupSizes(i) - 1));
                    jidx = jidx + groupSizes(i);
                end

                sourcedata = struct( ...
                    'GroupName', num2cell(groupNames), ...
                    'GroupSize', num2cell(groupSizes), ...
                    'GroupChildren', groupChildren ...
                    );
                
                pcaresult.SrcData = sourcedata;
                pcaresult.DataSizes = dataSizes;
                
            else
                % No data
                warning("No data has been selected");
                
            end
            
        end
        
        
        function [sortedData, groupNames, groupSizes, dataSizes] = sortdata(self, options)
            %SORTDATA Output sorted list of data and corresponding group
            %names and group sizes
            
            arguments
                self;                               % Analysis Subset
                options.Selection = self.DataSet;   % Selection
                options.FlatSizes = false;          % Roll out sizes?
            end
            
            % Take data from provided selection
            data = options.Selection;
                                    
            if ~isempty(data)
                % Get list of groups
                grouplist = self.getParentGroups(data, ExclusiveDataType="SpecData");
                
                % Get only spectral data
                data = data([data.dataType] == 'SpecData');
                
                % Check whether we have group information for all data
                if (numel(grouplist) ~= numel(data))
                    warning("Data selection failed.");
                    return
                end
                                
                % Sort data by group
                [groups, ~, groupIdx] = unique(grouplist);
                [sortedGroupIdx, sortingIdx] = sort(groupIdx);
                
                sortedData = data(sortingIdx);
                
                groupNames = vertcat( groups.DisplayName );
                
                % Get data sizes
                if options.FlatSizes
                    % Get all sizes and count spectra of LA scans as
                    % individual data
                    dataSizes = vertcat( sortedData.DataSize ); 
                else
                    % Take LA Scans as single data containers
                    dataSizes = ones(numel(sortedData), 1);
                end
                
                groupSizes = accumarray( sortedGroupIdx, dataSizes);
                
            end
            
        end
        
        
        function groupList = getParentGroups(self, dataContainer, options)
            %GETPARENTGROUPS Get parent groups belonging to data containers
            
            arguments
                self
                dataContainer
                options.ExclusiveDataType = [];
            end
            
            groupList = AnalysisGroup.empty();
            
            for i = 1 : numel(dataContainer)
                datacon = dataContainer(i);
                
                if ~isempty(options.ExclusiveDataType)
                    if (datacon.dataType ~= options.ExclusiveDataType)
                        % Different data type: skip data container
                        
                        continue;
                    end
                end
                
                for j = 1 : numel(self.GroupSet)
                    % Look in each group
                    group = self.GroupSet(j);
                    
                    if any(group.Children == datacon)
                        % Found datacon in current group
                        
                        groupList(end + 1) = group;
                    end
                end
            end
        end
        
        function set.Selection(self, selection)
            %SELECTION Update the list of selected data containers
            %   Input:
            %   selection:  can be either list of datacontainers or of GUI
            %   tree nodes
            
            datacontainers = DataContainer.empty();
            
            % Type-Based
            switch class(selection)
                case "matlab.ui.container.TreeNode"
                    % Tree nodes provided
                    
                    % Only include nodes that contain data
                    for i=1:numel(selection)
                        if class(selection(i).NodeData) == "DataContainer"
                            datacontainers(end+1) = selection(i).NodeData;
                        end
                    end
                    
                case "DataContainer"
                    % Actual datacontainers provided
                    
                    datacontainers = selection;
                    
            end
            
            % Check whether provided selection actually only contains
            % elements that are present in this analysis
            datacontainers = intersect(self.DataSet, datacontainers);
            
            % Update Selection
            self.Selection = datacontainers;
            
        end

        %% Destructor
        
        function delete(self)
            %DESTRUCTOR Delete all references to object

            fprintf("Deleting %s...", self.DisplayName);

            % Delete all analysis groups (children)
            for i = 1:numel(self.GroupSet)
                if isvalid(self.GroupSet(i))
                    delete(self.GroupSet(i));
                end
            end
            
            % Delete references at parent
            prj = self.Parent;
            
            if ~isvalid(prj)
                % Program is probably closing, prj hasn't been found
                % Skip checks
                return
                
            end
            
            % Remove itself from the dataset
            idx = find(self == prj.AnalysisSet);
            prj.AnalysisSet(idx) = [];

            fprintf(" (%d analysis groups have been removed as well)\n", i);

        end
            
    end
end

