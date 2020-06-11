classdef DataItem < matlab.mixin.Heterogeneous
    %DATAITEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Description;
    end
    
    properties (Abstract, SetAccess = private)
        Type;
    end
    
    methods (Sealed)
        function t = listItems(self)
            dummy = zeros(numel(self), 1);
            types = {self.Type}';
            descriptions = {self.Description}';
            
            t = table(dummy, types, descriptions);
        end
    end
end

