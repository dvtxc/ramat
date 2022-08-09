classdef TextData < DataItem
    %TEXTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data;
    end
    
    properties (SetAccess = private)
        Type = "TextData";
    end
    
    methods
        function self = TextData(name, data)
            %TEXTDATA Construct an instance of this class
            %   Detailed explanation goes here

            arguments
                name string = "";
                data string = "";
            end
            
            self.name = name;
            self.data = data;
            
        end
        
    end
end

