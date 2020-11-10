classdef DataItem < handle & matlab.mixin.Heterogeneous
    %DATAITEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name;
        Description;
    end
    
    properties (Abstract, SetAccess = private)
        Type;
    end
    
    methods (Sealed)
        function T = listItems(self)
            %LISTITEMS: brief overview
            
            T = table(self);
            T = T(:, {'Name', 'Description'});
        end

        function T = table(self)
            %TABLE Output data formatted as table
            %   This method overrides table() and replaces the need for
            %   struct2table()
            
            T = struct2table(struct(self));
            
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

