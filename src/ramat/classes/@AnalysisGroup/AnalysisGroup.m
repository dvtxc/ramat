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

        function s = struct(self, options)
            %STRUCT Output data formatted as structure
            %   This method overrides struct()
            %   Convert AnalysisGroups to struct containing references to
            %   the linked data containers.

            arguments
                self AnalysisGroup;
                options.selection logical = false;
                options.custom_selection DataContainer = DataContainer.empty;
                options.specdata logical = false;
                options.accumsize logical = false;
            end
            
            s = struct();
            for i = 1:numel(self)
                s(i).name = self(i).display_name;

                % Filter selection only
                if options.selection
                    s(i).children = intersect(self(i).children, self(i).parent.Selection);
                elseif ~isempty(options.custom_selection)
                    s(i).children = intersect(self(i).children, options.custom_selection);
                else
                    s(i).children = self(i).children;
                end

                % Get handles to data items (SpecData) instead of
                % containers
                if options.specdata
                    s(i).specdata = s(i).children.getDataHandles("SpecData");
                end

                % Get accumulated sizes
                if (options.specdata && options.accumsize)
                    s(i).accumsize = sum([s(i).specdata.DataSize]);
                end

            end
            
        end

        function remove(self)
            %REMOVE Soft Destructor
            
            % Unset at parent
            self.parent.GroupSet(self.parent.GroupSet == self) = [];

            % Destruct
            self.delete();

        end
        
    end
end

