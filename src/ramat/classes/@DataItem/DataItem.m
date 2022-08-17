classdef (Abstract) DataItem < handle & matlab.mixin.Heterogeneous & matlab.mixin.Copyable
    %DATAITEM Abstract parent class of all data items
    %   Subclasses are:
    %   PCAResult, ImageData, SpecData, SpecFilter, TextData, PeakTable,
    %   Mask
    
    properties
        name string;
        description string;
        parent_container {mustBeA(parent_container, 'Container')} = DataContainer.empty();
    end
    
    properties (Abstract, SetAccess = private)
        Type;
    end

    properties (SetAccess = private, GetAccess = private)
        format_list = "";
    end
        
    methods (Sealed)
        function append_sibling(self, new_data_item)
            %APPENDSIBLING Appends a new data item to parent data container
            %   Appends the new data item NEW_DATA_ITEM to the parent data
            %   container of SELF.
            %
            %   TO-DO: make it possible to append to array of DataItems

            arguments
                self
                new_data_item {mustBeA(new_data_item, 'DataItem')} = SpecData.empty();
            end

            if isempty(self.parent_container) || ~isvalid(self.parent_container)
                % Handle to deleted object?
                return
            end

            % Append DataItem
            self.parent_container.append_child(new_data_item);
            
        end


        function T = listItems(self)
            %LISTITEMS: brief overview
            
            T = self.totable();
            T = T(:, {'Type', 'Description'});
        end

        function T = totable(self)
            %TABLE Output data formatted as table
            %   This method overrides table() and replaces the need for
            %   struct2table()
            T = struct2table(struct(self));
            
        end
        
        function s = struct(self)
            %STRUCT Output data formatted as structure
            %   This method overrides struct()
            
            s = struct();
            for i = 1:numel(self)
                s(i).Type = self(i).Type;
                s(i).Description = self(i).Description;
                s(i).DataItem = self(i);
            end
            
        end

        function o = eq(a, b)
            %EQ Overloading equality operator "==" with Sealed = true, as
            %required for heterogeneous arrays in MATLAB
            o = eq@handle(a,b);
        end

    end

    methods
        function [ax, f] = plot(self, kwargs)
            % Get axes handle or create new figure window with empty axes

            arguments
                self;
                kwargs.Axes = [];
                kwargs.reset logical = true;
            end

            if isempty(kwargs.Axes)
                f = figure;
                ax = axes('Parent',f);
            else
                if ( class(kwargs.Axes) == "matlab.graphics.axis.Axes" || class(kwargs.Axes) == "matlab.ui.control.UIAxes")
                    ax = kwargs.Axes;
        
                    % Get figure parent, might not be direct parent of axes
                    f = get_parent_figure(ax);
                    
                    % Clear axes
                    if kwargs.reset, cla(ax, 'reset'); end
                else
                    warning("Invalid Axes Handle");
                    return;
                    
                end
            end
        end

        function [file, path] = export(self, options)
            %EXPORT

            arguments
                self {mustBeA(self, "DataItem")};
                options.path string = "";
                options.format string = "";
                options.format_list string = self.format_list;
            end

            format = options.format;
           
            if options.format == ""
                format = options.format_list;
            end

            pathfilter = self.get_export_filter(format);
            [file, path] = uiputfile(pathfilter, 'Export Data Item');

        end

        function get_context_actions(self, cm, node, app)
            %GET_CONTEXT_ACTIONS Retrieve all (possible) actions for this
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

            menu_item = uimenu(cm, ...
                Text="Remove",MenuSelectedFcn={@remove, self, node});

            function remove(~, ~, self, node)
                self.remove();
                update_node(node, "remove");
            end

        end

        function remove(self)
            %REMOVE Soft Destructor

            self.parent_container.children(self.parent_container.children == self) = [];
            self.delete();

        end

        
    end

    methods (Static)
        function pathfilter = get_export_filter(format_list)
            %GET_EXPORT_FILTER Get list of possible export file types

            pathfilter = cell.empty(0,2);

            if any(format_list == "csv"), pathfilter = [pathfilter; {'*.csv;*.txt', 'Comma-separated values (*.csv,*.txt)'}]; end
            if any(format_list == "mat"), pathfilter = [pathfilter; {'*.mat', 'MAT-files (*.mat)'}]; end

            pathfilter = [pathfilter; {'*.*', 'All Files (*.*)'}];

        end
    end
    
end

