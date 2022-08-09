classdef DataContainer < Container
    %DATACONTAINER Class
    %   Parent Class: Container
    %
    %   This object class contains all data objects belonging to a single
    %   measurement. It can contain multiple Data Items (e.g. SpecData
    %   Instances)
    %
    %   Properties inherited from parent class "Container"
    %       name            string
    %       parent          Group
    %       parent_project  Project
    %       children        DataItem
    %       dataType        string (abstract)
    %       display_name    string
    %       prev            Container
    %       next            Container
    %
    %   Methods inherited from parent class "Container"
    %       move_to_group(Group): void
    %       setgroup(Group): void
    %       append_child()
    %       struct(): struct
    %       table(): table

    properties (Access = public, Dependent)
        Data {mustBeA(Data, "DataItem")};
        DataPreview;
        AnalysisGroupParent;
        dataType;
    end

    % Method signatures
    methods (Access = public)
        specop(self, operation, kwargs);    % Wrapper for spec ops
        ax = plot(self, kwargs);
        subsetHandle = addToNewSubset(self);
        addToSubset(self, subsetHandle);
    end

    % Full method definitions
    methods
        function self = DataContainer(name, parent_prj, data_items)
            %DATACONTAINER Construct an instance of this class

            arguments
                name string = "";
                parent_prj Project = Project.empty();
                data_items {mustBeA(data_items, "DataItem")} = SpecData.empty();
            end

            self.name = name;
            self.parent_project = parent_prj;
            
            if ~isempty(data_items)
                self.append_data_item(data_items);
            end
            
        end
        
        function h = get.Data(self)
            % Return handle for the last/active data item
            
            if numel(self.children)    
                % Container contains data items, return last one of
                % following types: SpecData, ImageData, TextData
                dataitemtypes = self.listDataItemTypes();
                
                if any(dataitemtypes == "SpecData")
                    h = self.children( find(dataitemtypes == "SpecData", 1, 'last') );
                elseif any(dataitemtypes == "ImageData")
                    h = self.children( find(dataitemtypes == "ImageData", 1, 'last') );
                elseif any(dataitemtypes == "TextData")
                    h = self.children( find(dataitemtypes == "TextData", 1, 'last') );
                else
                    h = self.children(end);
                end
                
            else
                % Container is empty, return empty DataItem instance
                h = DataItem.empty;
            end
        end
        
        
        function duplicateData(self, datatype)
            
            if nargin > 1
                h = self.getDataHandles(datatype);
            else
                h = self.getDataHandles();
            end
                
            duplicates = copy(h);
            
            self.appendSpecData( duplicates );
            
            
        end
        

        
        function h = getDataHandles(self, data_type)
            % Get handles of spectral data objects
            
            if nargin > 1
                try
                    set = findobj(self, 'dataType', data_type);
                    h = vertcat(set.Data);
                catch
                    warning('Could not find suitable data.');
                    h = [];
                end
            else
                % Get all handles of DataItem() child classes within the
                % DataContainer() instances.
                h = vertcat(self.Data);
            end
            
        end
        
   
                
        %% Getters and setters of Dependent Properties

              
        function dataType = get.dataType(self)
            %DATATYPE GETTER
            %   Get Type attribute value of active DataItem instance.
            
            if numel(self.children)
                % DataContainer contains data items
                % Get Type attribute value
                dataType = self.Data.Type;
                
            else
                % DataContainer does not contain any data items
                dataType = "empty";
                
            end
        end


        
        function graph = get.DataPreview(self)
            % Get a data preview
            
            if (self.dataType == "SpecData")
                graph = self.Data.get_single_spectrum();
            else
                graph = [];
            end
            
        end
                
        function analysisGroupParent = get.AnalysisGroupParent(self)
            %ANALYSISGROUPPARENT Retrieve analysis group this data
            %container has been assigned to.

            warning("DataContainer.AnalysisGroupParent is deprecated.");
            
            % Search in project.
            prj = self.parent_project;
            analysisGroupParent = AnalysisGroup.empty;

            if isempty(prj)
                return;
            end

            
            % Search in analysis sets.
            for i = 1 : numel(prj.AnalysisSet)
                subset = prj.AnalysisSet(i);
                
                % Search in analysis groups.
                for j = 1:numel(subset.GroupSet)
                    subsetgroup = subset.GroupSet(j);
                    
                    if any(self == subsetgroup.Children)
                        % Parent found.
                        analysisGroupParent = subsetgroup;
                        
                    end
                    
                end
            end
        end
        
        
        
        %% Overrides
        
        function maxval = max(self)
            %MAX Returns maximum value of Data attribute
            
            maxval = max( vertcat( self.DataPreview ) );
            
        end

        function avg_datacontainer = mean(self)
            % MEAN Returns averaged spectra

            % Calculate mean
            specdat = self.getDataHandles;
            avg_specdat = specdat.mean();
            avg_datacontainer = DataContainer(avg_specdat.Name);
            avg_datacontainer.appendDataItem(avg_specdat);

        end
        
        %% Other methods
        function t = listDataItems(self)
            t = listItems(self.DataItems);
        end
        
        function types = listDataItemTypes(self)
            %LISTDATAITEMTYPES Returns array of data item types
            types = vertcat(self.children.Type);
            
        end
                
        function idx = currentlySelectedDataItem(self)
            idx = numel(self.DataItems);
        end
        
    end
    
    methods (Hidden) %DEBUGGING
        function dbg(obj)
            keyboard
        end
    end
    
end

