classdef AnalysisGroup < handle
    %ANALYSISGROUP Analysis Group class which contains DataContainers
    %   These groups are used for grouping in plots and pca analysis
    
    properties (Access = public)
        name string = "";
        children DataContainer;
        parent Analysis;
        parent_project Project;
    end
    
    properties (Access = public, Dependent)
        display_name string;
    end
    
    methods
        function self = AnalysisGroup(parent, name, data)
            %CONSTRUCTOR

            arguments
                parent Analysis;
                name string = "";
                data DataContainer = DataContainer.empty;
            end

            self.parent = parent;
            self.parent_project = parent.parent;

            self.name = name;
            self.children = data;
            
        end
        
        function append_data(self, data)
            %APPEND_DATA Append data to children of current analysis group
            %   data:   nx1 DataContainer
            
            self.children = [self.children; data];
            
            % TO-DO: checks
        end
        
        function set.name(self, newname)
            self.name = newname;
        end
        
        function displayname = get.display_name(self)
            %DISPLAYNAME Format name nicely
            
            if (self.name == "")
                displayname = "Unnamed Analysis Group";
            else
                displayname = string( self.name );
            end
        end
        
    end
end

