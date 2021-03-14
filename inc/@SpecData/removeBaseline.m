function self = removeBaseline(self)
% Returns object with baseline removed
% NaN-safe and preserves NaN values

for i = 1:numel(self)
    % Retrieve flattened 2-dimensional array
    flatdat = self(i).FlatDataArray;
    nSpectra = self(i).XSize * self(i).YSize;
        
    % Make NaN-safe
    nan_array = isnan(flatdat);
    nan_columns = max(nan_array, [], 1);
    has_nan = any(nan_columns);
    if has_nan
        % Return array with solely actual numbers
        numerical_columns = ~nan_columns;
        flatdat = flatdat(:, numerical_columns);
        nSpectra = size(flatdat, 2);
    end
    
    if (nSpectra > 100)
        fprintf('--- Removing baseline from %i spectra. This might take a while.\n', nSpectra)
    end
    
    % Perform removal of baseline
    adjusted_data = msbackadj(repmat(self(i).Graph, 1, nSpectra), ...
        flatdat, ...
        'WindowSize', 200, ...
        'StepSize', 200, ...
        'RegressionMethod', 'pchip', ...
        'EstimationMethod', 'quantile', ...
        'QuantileValue', 0.10);
    
    % Return adjusted data into spectral object
    if has_nan
        % Only update the numerical columns
        rows = boolean(ones(1, self(i).GraphSize));
        self(i).Data( rows , numerical_columns ) = adjusted_data;
    else
        self(i).Data = adjusted_data;
    end
    
end

end

