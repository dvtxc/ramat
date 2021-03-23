classdef Project < handle
    %PROJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DataSet = DataContainer.empty;
        GroupSet = Group.empty;
        AnalysisSet = Analysis.empty;
        Name = "";
    end
    
    methods
        function append_data(self, dataset)
            %APPEND_DATA:
            %   Appends a dataset to the project object

            self.DataSet = [self.DataSet; dataset];
            
            % Create a new group for the newly appended data
            newGroup = self.add_group("New Import");
            dataset.setgroup( newGroup );
        end
        
        function newGroup = add_group(self, groupname)
            %ADD_GROUP
            
            newGroup = Group( groupname );
            self.GroupSet(end + 1) = newGroup;
            
        end
        
    end
end

