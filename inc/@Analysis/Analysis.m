classdef Analysis < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        DataSet = DataContainer.empty;
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

    end
end

