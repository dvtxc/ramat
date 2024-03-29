classdef TextData < DataItem
    %TEXTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Data;
        XSize = 0;
        YSize = 0;
        ZSize = 0;
        DataSize = 0;
    end
    
    properties (SetAccess = private)
        Type = "TextData";
    end
    
    methods
        function self = TextData(name, data)
            %TEXTDATA Construct an instance of this class
            %   Detailed explanation goes here
            
            if (nargin == 0)
                self.Name = "";
                self.Data = "";
                
                return;
            end
            
            self.Name = name;
            self.Data = data;
            
        end
        
    end
end

