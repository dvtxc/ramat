classdef ImageData < DataItem
    %IMAGEDATA 
    
    properties
        Data;
    end
    
    properties (Dependent)
        XSize;
        YSize;
        ZSize;
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
        
        function xres = get.XSize(self)
            xres = size(self.Data, 1);
        end
        
        function yres = get.YSize(self)
            yres = size(self.Data, 2);
        end
        
        function zres = get.ZSize(self)
            % TO BE IMPLEMENTED
            zres = 0;
        end
        
    end
end
