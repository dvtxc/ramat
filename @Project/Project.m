classdef Project < handle
    %PROJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DataSet = DataContainer.empty;
        GroupSet = Group.empty;
    end
    
    methods
        function append_data(self, dataset)
            %APPEND_DATA:
            %   Appends a dataset to the project object

            self.DataSet = [self.DataSet; dataset];
        end
        
        function add_group(self, groupname)
            %ADD_GROUP
            
            self.GroupSet(end + 1) = Group( groupname );
        end
    end
end

