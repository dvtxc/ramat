classdef SpecData < DataItem
    %SPECDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        XData;
        YData;
    end
    
    properties (SetAccess = private)
        Type = "SpecData";
    end
    
    methods
        function obj = SpecData(desc,xdat,ydat)
            %SPECDATA Construct an instance of this class
            %   Stores x-data and y-data
            
            if (nargin > 0)
                obj.Description = desc;
                obj.XData = xdat;
                obj.YData = ydat;
            else
                obj.Description = "empty";
                obj.XData = [];
                obj.YData = [];
            end
        end
        
        function obj = trimSpectrum(obj, startX, endX)
            if (endX > startX)
                for i = 1:numel(obj)
                    xdat = obj(i).XData;
                    ydat = obj(i).YData;

                    % Find indices of trim region
                    startIdx = find(xdat > startX, 1, 'first');
                    endIdx = find(xdat < endX, 1, 'last');

                    obj(i).XData = xdat( startIdx:endIdx , :);
                    obj(i).YData = ydat( startIdx:endIdx , :);
                end
            else
                warning('Trim region is invalid. Second values should be greater than the first value.');
            end
        end
        
        function obj = normalizeSpectrum(obj)
            for i = 1:numel(obj)
                ydat = obj(i).YData;
                
                obj(i).YData = ydat ./ sum(ydat);
            end
        end
        
        function obj = removeConstantOffset(obj)
            for i = 1:numel(obj)
                ydat = obj(i).YData;
                [~, wavResolution] = size(ydat);
                
                subtractionMatrix = repmat(min(ydat), wavResolution, 1);
                
                obj(i).YData = ydat - subtractionMatrix;
            end
        end
        
    end
end

