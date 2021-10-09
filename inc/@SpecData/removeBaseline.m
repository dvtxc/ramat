function self = removeBaseline(self, method, options)
    % Returns object with baseline removed
    % NaN-safe and preserves NaN values
    
    arguments
        self;
        method = 'builtin';
        options struct = [];
    end

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
        switch method
            case 'constant'
                % Subtract constant value
                minima = min(flatdat);
                adjusted_data = flatdat - minima;
                
            case 'builtin'
                xbase = repmat(self(i).Graph, 1, nSpectra);
                
                if isempty(options)
                    adjusted_data = bgs_builtinBackAdj(xbase, flatdat);
                else
                    celloptions = namedargs2cell(options);
                    
                    adjusted_data = bgs_builtinBackAdj(xbase, flatdat, celloptions{:});
                end
                
            case 'airPLS'
                adjusted_data = bgs_airPLS(flatdat, 10e4, 2, 0.05);
            otherwise
                return
        end
        

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
