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
            self.parent_container.appendDataItem(new_data_item);
            
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

