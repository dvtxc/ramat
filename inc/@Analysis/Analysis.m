classdef Analysis < handle
    %ANALYSIS Analysis subset used for PCA Analysis
    %   Detailed explanation goes here
    
    properties (Access = public)
        DataSet = DataContainer.empty;
        GroupSet = AnalysisGroup.empty;
        Parent = Project.empty;
        Selection = [];
        Name = "";
    end
    
    properties (Access = public, Dependent)
        DisplayName;
    end
    
    methods
        function self = Analysis(parentProject, dataset)
            %CONSTRUCTOR
            self.Parent = parentProject;
            self.DataSet = dataset;
        end
        
        function append_data(self, dataset)
            self.DataSet = [self.DataSet; dataset];
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
                self.DataSet(self.DataSet == datacon) = [];
                
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

    end
end

