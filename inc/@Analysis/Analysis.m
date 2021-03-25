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
        
        function add_group(varargin)
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

    end
end

