classdef Container < handle
    %CONTAINER Abstract parent class of DataContainer and
    %AnalysisResultContainer
    %   Can contain DataItems that are part of a measurement or an analysis
    %   result.

    properties
        name string;
        parent Group;
        project_parent Project;
        DataItems {mustBeA(DataItems, "DataItem")};
    end

    properties (Dependent)
        display_name string;
        prev Container;
        next Container;
    end

    methods (Sealed)
        function append_data_item(self, data_items)
            %APPENDDATAITEM
            %   Appends DataItem object to list of data items
            %   It can also append multiple DataItems objects to multiple
            %   DataContainer objects if the number of instances is equal.

            arguments
                self {mustBeA(self, "Container")};
                data_items {mustBeA(data_items, "DataItem")};
            end
            
            num_data_items = numel(data_items);
            num_self = numel(self);
        
            % Input sanitazation
            
            if ~(num_self == 1 || num_data_items == 1 || num_data_items == num_self)
                % The number of SpecData objects cannot be unambigeously
                % appended to the corresponding DataContainer instances.
                return
            end
        
            % Implementation
        
            if num_self == 1
                % Append new data item(s) to single Container
                for item = data_items
                    item.ParentContainer = self;
                    self.DataItems(end+1) = item;
                end
            
            else
                % Append new data item(s) to multiple Containers
        
                if num_data_items == 1
                    % Distribute single data item to multiple Containers
                    for container = self
                        data_items.ParentContainer = container;
                        container.DataItems(end + 1) = data_items;
                    end
        
                else
                    % Multiple DataItems to multiple DataContainers (1 to
                    % 1)
                    for i = 1 : num_self
                        new_item = data_items(i);
                        container = self(i);
        
                        new_item.ParentContainer = container;
                        container.DataItems(end + 1) = new_item;
                    end
        
                end
            end
        
        end

        function move_to_group(self, new_group)
            %MOVE_TO_GROUP Moves container to new group
            %

            arguments
                self Container;
                new_group Group = Group.empty();
            end

            % Check if new group is singular
            if numel(new_group) > 1
                warning('Cannot move to multiple groups at once');
                return;
            end

            % New group is invalid (i.e. deleted)
            if ~isvalid(new_group)
                warning('Reference to deleted group');
                return
            end

            % Move to a new group
            % Create new group when no group is given. Retrieve from first self.
            if isempty(new_group)
                new_group = self(1).project_parent.add_group("New Group");
            end

            % Remove from old group
            for i = 1:numel(self)
                self(i).parent.remove_child(self(i));
            end

            % Add to new group and set new group
            new_group.add_children(self);

        end

    end

    methods
        function display_name = get.display_name(self)
            %DISPLAY_NAME Readable display name

            display_name = self.name;

            if display_name == ""
                display_name = sprintf("unnamed %s", class(self));
            end

        end

        function prev = get.prev(self)
            %PREV Get previous sibling

            prev = [];

            if isempty(self.parent)
                return;
            end

            % Find itself in the list of children
            idx = find(self == self.parent.Children);

            if idx == 1
                return;
            else
                prev = self.parent.Children(idx - 1);
            end

        end

        function next = get.next(self)
            %PREV Get previous sibling

            next = [];

            if isempty(self.parent)
                return;
            end

            % Find itself in the list of children
            idx = find(self == self.parent.Children);

            if idx == numel(self.parent.Children)
                return;
            else
                next = self.parent.Children(idx + 1);
            end

        end


    end
end