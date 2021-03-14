function trimData(self, startx, endx, overwrite)
%TRIMDATA Trim spectral data
%   Checks whether the container has spectral data
%   Trims data to [start wavenumber] till [end wavenumber]

    for i = 1:numel(self)
        if (self(i).dataType == "SpecData")
            % Select last data item
            didx = numel(self(i).Data);

            try
                trimmedDataObj = trimSpectrum(self(i).Data(didx), startx, endx);

                if (overwrite == true)
                    self(i).Data(didx) = trimmedDataObj;
                else
                    newDescription = sprintf("Trim [%i - %i]", startx, endx);
                    self(i).addSpecData(newDescription, trimmedDataObj.XData, trimmedDataObj.YData);
                end

            catch
                warning('Could not trim spectral data.');
            end
        end
    end

end