classdef Analysis < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DataSet = DataContainer.empty;
        Parent = Project.empty;
        Selection = [];
        Name = "";
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
    end
end

