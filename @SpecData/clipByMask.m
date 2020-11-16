function clipByMask(self, binaryMask)
    %CLIP_BY_MASK Summary of this function goes here
    %   Detailed explanation goes here
    
    mask = double( binaryMask );
    mask( mask == 0 ) = NaN;
        
    for i = 1 : numel(self)
        % For every instance of SpecData
        
        data = self(i).Data;
        
        try
            data = data .* mask;
        catch
            error('Could not apply mask.');
        end
        
        self(i).Data = data;
    end
    
end

