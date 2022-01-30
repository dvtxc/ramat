function appendDataItem(self, data_items)
    %APPENDDATAITEM
    %   Appends DataItem object to list of data items
    %   It can also append multiple DataItems objects to multiple
    %   DataContainer objects if the number of instances is equal.
    
    num_data_items = numel(data_items);
    num_self = numel(self);

    % Input sanitazation

    if ~isa(data_items, 'DataItem')
        % Not a DataItem
        return
    end
    
    if ~(num_self == 1 || num_data_items == 1 || num_data_items == num_self)
        % The number of SpecData objects cannot be unambigeously
        % appended to the corresponding DataContainer instances.
        return
    end

    % Implementation

    if num_self == 1
        % Append new data item(s) to single DataContainer

        for item = data_items
            item.ParentContainer = self;
            self.DataItems(end+1) = item;
        end
    
    else
        % Append new data item(s) to multiple DataContainers

        if num_data_items == 1
            % Distribute single data item to multiple data containers
            for dc = self
                data_items.ParentContainer = dc;
                dc.DataItems(end + 1) = data_items;
            end

        else
            % Multiple data items to multiple data containers
            for i = 1 : num_self
                new_item = data_items(i);
                dc = self(i);

                new_item.ParentContainer = dc;
                dc.DataItems(end + 1) = new_item;
            end

        end
    end

end