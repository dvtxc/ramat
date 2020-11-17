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
        
        function sizes = countGroupFlatDataSizes(self, omitnan)
            %COUNTGROUPFLATDATASIZES
            %   Since groups are stored in DataContainer, we need to
            %   calculate the flat data sizes of the contained data items
            %   here.
            
            sizes = zeros( numel(self), 1 );
            
            for i = 1:numel(self)
                % For every instance of Group.
                
                % Get handles of all instances of DataContainer() within
                % the current instance Group() that contain spectral data.
                h = self(i).Children.getDataHandles('SpecData');
                      
                if (nargin > 1 && strcmp(omitnan, 'omitnan'))
                    % Calculate number of spectra, whilst omitting
                    % NaN-spectra.
                    sizes(i) = sum( ~any( isnan( horzcat(h.FlatDataArray) ) ) );
                else
                    % Calculate number of spectra, including NaN-spectra.
                    sizes(i) = size( horzcat( h.Data.FlatDataArray ), 2);
                end

            end
 
        end
        
        pcaresult = groupedPCA(self);
        
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

