classdef Analysis < handle
    %ANALYSIS Analysis subset used for PCA Analysis
    %   Detailed explanation goes here
    
    properties (Access = public)
%         DataSet = DataContainer.empty;
        GroupSet = AnalysisGroup.empty;
        Parent = Project.empty;
        Selection = [];
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
        
        function append_data(self, dataset)
            
            newgroup = self.add_group();
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
            %DATASET Ungrouped data set of this analysis subset.
            
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
        
        function pcaresult = compute_pca(self, options)
            %COMPUTE_PCA Compute a principle component analysis (PCA) of
            %current analysis subset.
            %Input:
            %   self
            %   options.Range:      range [2x1 array] in cm^-1
            %   options.Selection   selection of DataContainers
            %
            %Output:
            %   pcaresult:  PCAResult object
            
            arguments
                self Analysis
                options.Range (2,1) double = [];
                options.Selection (:,:) DataContainer = DataContainer.empty;
            end
                        
            % Get handles of selected data containers
            if isempty(options.Selection)
                % No selection has been provided, take all data containers
                % in the current analysis
                data = self.DataSet;
                
            else
                % Selection has been provided
                
                % Make sure the selection corresponds to data that is
                % within this analysis subset
                % TO-DO
                
                data = options.Selection;
                
            end
                
            
            if isempty(options.Range)
                pcaresult = data.calculatePCA();
            else
                pcaresult = data.calculatePCA(options.Range);
            end
        end

    end
end

