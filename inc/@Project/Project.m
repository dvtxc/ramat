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
        
        function newGroupHandle = add_group(self, groupname)
            %ADD_GROUP
            
            newGroupHandle = Group( groupname );
            self.GroupSet(end + 1) = newGroupHandle;
            
        end
        
        function newAnalysisHandle = add_analysis(self, dataset)
            %ADD_ANALYSIS
            %   Add a new data subset for analysis
            %   Returns:    handle to new analysis subset
            
            newAnalysisHandle = Analysis(self, dataset);
            self.AnalysisSet = [self.AnalysisSet; newAnalysisHandle];
        end
        
    end
end

