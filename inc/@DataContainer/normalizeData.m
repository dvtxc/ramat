function normalizeData(self, options)
%NORMALIZEDATA Normalize spectral data
%   Checks whether the container has spectral data
%   Normalizes data, so sum = 1

    arguments
        self;
        options.Overwrite logical = true;
    end

    for i = 1:numel(self)
        
        % Only perform operation on spectral data
        if (self(i).dataType == "SpecData")

            try
                % Bool, overwrite last dataitem in container?
                if (options.Overwrite == true)
                    self(i).Data.normalizeSpectrum();
                    
                else
                    % Create normalized copy
                    newSpecDat = copy(self(i).Data);
                    newSpecDat.Description = "Normalize";
                    newSpecDat.normalizeSpectrum();
                    
                    % Append to self.DataItems
                    self(i).appendSpecData(newSpecDat);
                    
                end

            catch
                warning('Could not normalize spectral data.');
            end

        end
    end
end