classdef ImageData
    %IMAGEDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Data;
    end
    
    properties (SetAccess = private)
        Type = "ImageData";
    end
    
    methods
        function self = ImageData(name, data)
            %IMAGEDATA Construct an instance of this class
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
