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
        subsetHandle = add_to_new_subset(self);
        add_to_subset(self, subsetHandle);
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
        

        function add_context_actions(self, cm, node, app)
            %ADD_CONTEXT_ACTIONS Retrieve all (possible) actions for this
            %data item that should be displayed in the context menu
            %   This function adds menu items to the context menu, which
            %   link to specific context actions for this data item.
            %
            arguments
                self;
                cm matlab.ui.container.ContextMenu;
                node matlab.ui.container.TreeNode;
                app ramatguiapp;
            end

            % Add "add to analysis set" menu nodes
            node_add_to = uimenu(cm, 'Text', 'Add to Analysis Set ...');
            uimenu(node_add_to, ...
                'Text', '<New Analysis>', ...
                'Callback', {@add_to_new_analysis, app});

            % Populate sub menu with all available analysis sets
            for analysis = app.prj.analyses(:)'
                name = analysis.display_name;
                uimenu(node_add_to, ...
                    'Text', name, ...       % Name of analysis subset
                    'Callback', {@add_to_analysis, app, analysis}); 
            end

            % Move to Group <xy>
            node_move_to = uimenu(cm, 'Text', 'Move to Group ...');
            uimenu(node_move_to, ...
                'Text', '<New Group>', ...
                'Callback', {@MovetoGroupSelected, Group.empty()});
            
            % Populate sub menu with all groups
            gen_child_group_nodes(node_move_to, app.prj.data_root, app);

            function gen_child_group_nodes(parent_node, group, app)
                %GEN_CHILD_GROUP_NODES Recursive function to generate all
                %child nodes
                
                % MATLAB automatically executes callback when child menus
                % are present, so always add one more child menu with
                % actual callback
                group_node = uimenu(parent_node, ...
                    'Text', group.display_name);
                uimenu(group_node, ...
                    'Text', sprintf("Move to %s", group.display_name), ...
                    "Callback", {@move_to_group, app, group, Group.empty()});

                % Recursion
                for child = group.child_groups
                    gen_child_group_nodes(group_node, child, app)
                end

                % To new group in current group
                uimenu(group_node, ...
                    'Text', "<New Group>", ...
                    "Callback", {@move_to_group, app, Group.empty(), group});

            end
            
            add_context_actions@Container(self, cm, node, app);

            function add_to_new_analysis(~,~,app)
                % User has selected <ADD TO NEW ANALYSIS>

                % Get handles to selected data containers
                h = vertcat(app.DataMgrTree.SelectedNodes.NodeData);
                
                h.add_to_new_subset();
                
                % Update GUI Managers
                app.updatemgr(Parts=[2,3]);
            end

            function add_to_analysis(~, ~, app, analysis)
                % User has selected <ADD TO ANALYSIS>
                
                % Get handles to selected data containers
                h = vertcat(app.DataMgrTree.SelectedNodes.NodeData);
                
                h.add_to_subset(analysis);
                
                % Update GUI Managers
                app.updatemgr(Parts=3);
            end

            function move_to_group(~, ~, app, group_handle, parent_group)
                % User has selected <MOVE TO GROUP xy>

                % Get selected dataset handles
                dataset = vertcat(app.DataMgrTree.SelectedNodes.NodeData);

                % Move dataset
                dataset.move_to_group(group_handle, parent_group);

                % Update datamgr
                app.updatemgr();
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
        
        function icon = get_icon(self)
            %ICON Gets icon, based on data

            % Retrieve default icon for DataContainer
            icon = get_icon@Container(self);
            if isempty(self.Data), return; end

            % Retrieve icon, based on current data item
            icon = self.Data.icon;
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

