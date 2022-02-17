classdef Group < handle
    %GROUP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        Name;
        Parent;
        Children;
    end
    
    properties (Access = public, Dependent)
%         Children
    end
    
    properties (Access = public)
        ProjectParent;
        ID;
    end
       
    methods
        function self = Group(parent, name)
            %GROUP Construct an instance of this class
            %   Detailed explanation goes here

            arguments
                parent Project = [];
                name string = "";
            end
            
            self.Parent = parent;
            self.Name = name;

            global prj
            
            if ~isempty(prj)
                self.ProjectParent = prj;
            end
            
            
        end

        function add_children(self, dataset)
            %ADD_CHILDREN Adds children containers and sets their group
            %
            %   Usage:
            %   add_children(group, datacon_arr)

            arguments
                self Group;
                dataset DataContainer = [];
            end

            % Append to list of children
            self.Children = [self.Children; dataset];

            % Set group
            dataset.setgroup(self);

        end

        function remove_child(self, dataset)
            %REMOVE_CHILD Deletes child
            %   Checks if dataset is part of children and removes it from
            %   the list of children

            arguments
                self Group;
                dataset DataContainer;
            end

            % Unset the corresponding children
            idx = find(dataset == self.Children);
            self.Children(idx) = [];

        end
        
%         function children = get.Children(self) - DEPRECATED
%             %global prj
%             
%             if ~isempty(self.ProjectParent)
%                 children = self.ProjectParent.DataSet.findgroup( self );
%             end
%         end
        
        function id = getid(self)
            id = vertcat(self.ID);
        end
        
       
        
        function specplot(self, stacked)
            % SPECPLOT
            
            fig = figure;
            hold on
            
            for i = 1:numel(self)
                % For every instance of Group()
                
                % Get handles of all instances of DataContainer() within
                % the current instance Group() that contain spectral data.
                h = self(i).Children.getDataHandles('SpecData');
                
                xdata = [];
                ydata = [];
                
                if ~isempty(h)
                    % TO-DO: implement a check for uniform GRAPHDATA
                    xdata = h(1).Graph;
                    ydata = mean( horzcat( h.FlatDataArray ), 2, 'omitnan');
                    
                    if nargin>1
                        if stacked == 1
                            ydata = ydata - 0.01 .* (mod(i,2) - 1);
                        end
                    end
                    
                end
                
                plot(xdata, ydata);
                                
            end
            
            legend({self.Name}');
            
        end
        
        pcaresult = groupedPCA(self, range);
        
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

%         function sizes = countGroupFlatDataSizes(self, omitnan)
%             %COUNTGROUPFLATDATASIZES -- DEPRECATED
%             %   Since groups are stored in DataContainer, we need to
%             %   calculate the flat data sizes of the contained data items
%             %   here.
%             
%             sizes = zeros( numel(self), 1 );
%             
%             for i = 1:numel(self)
%                 % For every instance of Group.
%                 
%                 % Get handles of all instances of DataContainer() within
%                 % the current instance Group() that contain spectral data.
%                 h = self(i).Children.getDataHandles('SpecData');
%                       
%                 if ~isempty(h)
%                     % Current instance of Group() has instances of
%                     % DataContainer()
%                 
%                     if (nargin > 1 && strcmp(omitnan, 'omitnan'))
%                         % Calculate number of spectra, whilst OMITTING
%                         % NaN-spectra.
%                         sizes(i) = sum( ~any( isnan( horzcat(h.FlatDataArray) ) ) );
%                     else
%                         % Calculate number of spectra, INCLUDING NaN-spectra.
%                         sizes(i) = size( horzcat( h.Data.FlatDataArray ), 2);
%                     end
%                 else
%                     % Current instance of Group() is empty or has
%                     % non-spectral data.
%                     sizes(i) = 0;
%                 end
% 
%             end
%  
%         end
        
    end
end

