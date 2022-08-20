classdef ImageData < DataItem
    %IMAGEDATA 
    
    properties
        data;
    end
    
    properties (Dependent)
        XSize;
        YSize;
        ZSize;
        DataSize;
    end
    
    properties (SetAccess = private)
        Type = "ImageData";
    end
    
    methods
        function self = ImageData(name, data)
            %IMAGEDATA Construct an instance of this class
            %   Detailed explanation goes here
            
            arguments
                name string = "";
                data double = [];
            end
            
            self.name = name;
            self.data = data;
            
        end
        
        function xres = get.XSize(self)
            xres = size(self.data, 1);
        end
        
        function yres = get.YSize(self)
            yres = size(self.data, 2);
        end
        
        function zres = get.ZSize(self)
            % TO BE IMPLEMENTED
            zres = 1;
        end
        
        function datares = get.DataSize(self)
            datares = self.XSize * self.YSize * self.ZSize;
        end

        function icon = get_icon(self)
            %GET_ICON Overrides <DataItem>.icon dependent property.
            icon = "TDImage.png";
        end
        
    end
end
