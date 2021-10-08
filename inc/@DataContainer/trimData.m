function trimData(self, startx, endx, options)
%TRIMDATA Trim spectral data
%   Checks whether the container has spectral data
%   Trims data to [start wavenumber] till [end wavenumber]
    
    arguments
        self;
        startx double;
        endx double;
        options.Overwrite logical = true;
    end

    for i = 1:numel(self)
        
        % Only perform operation on spectral data
        if (self(i).dataType == "SpecData")

            try
                % Bool, overwrite last dataitem in container?
                if (options.Overwrite == true)
                    self(i).Data.trimSpectrum(startx, endx);
                    
                else
                    % Create trimmed copy
                    newSpecDat = copy(self.Data);
                    newSpecDat.Descritpion = sprintf("Trim [%i - %i]", startx, endx);
                    newSpecDat.trimSpectrum(startx, endx);
                    
                    % Append to self.DataItems
                    self(i).appendSpecData(newSpecDat);
                    
                end

            catch
                warning('Could not trim spectral data.');
            end
        end
    end

end