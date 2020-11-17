function clipByMask(self, binaryMask)
    %CLIP_BY_MASK Clips SpecData by a mask
    %   binaryMask should
        
    if (iscell(binaryMask) && numel(binaryMask) ~= numel(self))
        % The number of SpecData objects cannot be unambigeously
        % appended to the corresponding DataContainer instances.

        return
    end
    
    if isnumeric(binaryMask)
        mask = double( binaryMask );
        mask( mask == 0 ) = NaN;
    elseif (islogical(binaryMask) || iscell(binaryMask))
        mask = binaryMask;
    else
        return
    end
        
    for i = 1 : numel(self)
        % For every instance of SpecData
        
        if iscell(mask)
            % Multiple masks stored within a cell array.
            mask = double( mask{i} );
            mask( mask == 0 ) = NaN;
        end
        
        data = self(i).Data;
        
        try
            data = data .* mask;
        catch
            error('Could not apply mask.');
        end
        
        self(i).Data = data;
    end
    
end
