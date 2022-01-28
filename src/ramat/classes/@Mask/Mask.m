classdef Mask < DataItem
    %MASK Logical mask for area scans
    
    properties
        Data = logical.empty(); % Mask data
    end

    properties (Dependent)
        XSize;
        YSize;
        ZSize;
        DataSize;
    end

    properties (SetAccess = private)
        Type = "Mask";
    end
    
    methods
        function self = Mask(data, name)
            %MASK Construct an instance of this class
            
            % Empty mask
            if (nargin == 0)
                self.Name = "Mask";
                self.Data = "";
                return;
                
            end

            % Only data provided
            if (nargin == 1)
                self.Name = "Mask";
                self.Data = data;
                return;

            end

            % Mask
            self.Name = name;
            self.Data = data;
            
        end
        
        %% Dependent Properties

        function xres = get.XSize(self)
            xres = size(self.Data, 1);
        end
        
        function yres = get.YSize(self)
            yres = size(self.Data, 2);
        end
        
        function zres = get.ZSize(self)
            % TO BE IMPLEMENTED
            zres = 1;
        end
        
        function datares = get.DataSize(self)
            datares = self.XSize * self.YSize * self.ZSize;
        end
    end

end

