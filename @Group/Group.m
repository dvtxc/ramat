classdef Group < handle
    %GROUP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        Name;
    end
    
    properties (Access = public, Dependent)
        Children
    end
    
    properties (Access = public)
        ProjectParent;
        ID;
    end
       
    methods
        function self = Group(name)
            %GROUP Construct an instance of this class
            %   Detailed explanation goes here
            global prj
            
            if ~isempty(prj)
                self.ProjectParent = prj;
            end
            
            self.Name = name;
        end
        
        function children = get.Children(self)
            %global prj
            
            if ~isempty(self.ProjectParent)
                children = self.ProjectParent.DataSet.findgroup( self );
            end
        end
        
        function id = getid(self)
            id = vertcat(self.ID);
        end
        
        function sizes = countGroupFlatDataSizes(self)
            %COUNTGROUPFLATDATASIZES
            %   Since groups are stored in DataContainer, we need to
            %   calculate the flat data sizes of the contained data items
            %   here.
            sizes = [];
            groups = [];
            for i = 1:numel(self)
                for j = 1:numel(self(i).Children)
                    if (self(i).Children(j).dataType == "SpecData")
                        % Analyse datacontainer
                        dc = self(i).Children(j);
                        sizes(end + 1) = self.Data.XSize * self.Data.YSize;
                        groups(end + 1) = i;
                    end
                end
            end
            
            
        end
        
        function t = table(self)
            %TABLE Output data formatted as table
            %   This method overrides table() and replaces the need for
            %   struct2table()
            
            t = struct2table(struct(self), 'AsArray', true);
            
        end
        
        function s = struct(self)
            %STRUCT Output data formatted as structure
            %   This method overrides struct()
            
            publicProperties = properties(self);
            s = struct();
            for i = 1:numel(self)
                for j = 1:numel(publicProperties)
                    s(i).(publicProperties{j}) = self(i).(publicProperties{j}); 
                end 
            end
        end
        
    end
end

