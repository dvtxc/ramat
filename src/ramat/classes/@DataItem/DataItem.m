classdef DataItem < handle & matlab.mixin.Heterogeneous & matlab.mixin.Copyable
    %DATAITEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name;
        Description;
        ParentContainer = [];
    end
    
    properties (Abstract, SetAccess = private)
        Type;
    end
        
    % Following properties are needed for verbose table output. TO DO:
    % remove necessity to instantiate these properties in child classes for
    % clarity.
    properties (Abstract, SetAccess = public)
        XSize;
        YSize;
        ZSize;
        DataSize;
    end
    
    methods (Sealed)
        function append_sibling(self, new_data_item)
            %APPENDSIBLING Appends a new data item to parent data container
            %   Appends the new data item NEW_DATA_ITEM to the parent data
            %   container of SELF.
            %
            %   TO-DO: make it possible to append to array of DataItems

            if ~isa(new_data_item, 'DataItem')
                % Not a DataItem
                return
            end

            if isempty(self.ParentContainer) || ~isvalid(self.ParentContainer)
                % Handle to deleted object?
                return
            end

            % Append DataItem
            self.ParentContainer.appendDataItem(new_data_item);
            
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
        
    end
    
end

