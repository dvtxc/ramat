classdef AnalysisGroup < handle
    %ANALYSISGROUP New Group class which has child data containers as
    %public member
    %   This is the new "active" group class. Will eventually replace the
    %   passive group class. Currently used for analysis subsets.
    
    properties (Access = public)
        Name = "";
        Children;
        AnalysisParent;
    end
    
    properties (Access = public, Dependent)
        DisplayName;
    end
    
    properties (Access = private)
        ProjectParent;
    end
    
    methods
        function self = AnalysisGroup(varargin)
            %CONSTRUCTOR
            global prj
            
            if ~isempty(prj)
                self.ProjectParent = prj;
            end
            
            if (nargin == 1)
                % Construct empty AnalysisGroup
                parent = varargin{1};
                
                self.AnalysisParent = parent;
                
            elseif (nargin == 2)
                % Construct empty AnalysisGroup with name
                name = varargin{1};
                parent = varargin{2};
                
                self.Name = name;
                self.AnalysisParent = parent;
                
            elseif (nargin == 3)
                % Construct AnalysisGroup with DataContainers
                name = varargin{1};
                data = varargin{2};
                parent = varargin{3};
                
                self.Name = name;
                self.Children = data;
                self.AnalysisParent = parent;
                
            end
            
        end
        
        function append_data(self, data)
            %APPEND_DATA Append data to children of current analysis group
            %   data:   nx1 DataContainer
            
            self.Children = [self.Children; data];
            
            % TO-DO: checks
        end
        
        function displayname = get.DisplayName(self)
            %DISPLAYNAME Format name nicely
            
            if (self.Name == "")
                displayname = "Empty Group";
            else
                displayname = self.Name;
            end
        end
        
    end
end

