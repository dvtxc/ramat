classdef SpecFilter < DataItem
    %SPECFILTER Spectral Filter for Area Scans
    %   Detailed explanation goes here
    
    properties
        Range;  % Working Range of Filter
        Operation;  % Mathematical Operation to Perform
    end
    
    properties (SetAccess = private)
        Type = "SpecFilter";
    end
        
    methods
        function self = SpecFilter(options)
            %SPECFILTER Construct an instance of this class
            %   Detailed explanation goes here
            
            arguments
                options.Name string = "";
                options.Range double = [1000, 1300];
                options.Operation char = 'sum';
            end
            
            self.Name = options.Name;
            self.Range = options.Range;
            self.Operation = options.Operation;
            
        end
        
        function result = getResult(self, specdat)
            %   RESULT
            %   specdat:    Operand (Input)
            %   result:     Output
            
            idxrange = specdat.wavnumtoidx( self.Range );
            
            switch self.Operation
                case 'sum'
                    result = sum( specdat.Data(:, :, idxrange(1):idxrange(2)), 3);
                case 'avg'
                    result = mean( specdat.Data(:, :, idxrange(1):idxrange(2)), 3);
                case 'maxmin'
                    hi = max( specdat.Data(:, :, idxrange(1):idxrange(2)), [], 3);
                    lo = min( specdat.Data(:, :, idxrange(1):idxrange(2)), [], 3);
                    result = hi - lo;
            end
            
        end
    end
end

