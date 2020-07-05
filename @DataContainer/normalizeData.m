function normalizeData(self, overwrite)
%NORMALIZEDATA Normalize spectral data
%   Checks whether the container has spectral data
%   Normalizes data, so sum = 1

    for i = 1:numel(self)
        if (self(i).dataType == "SpecData")
            %Select last data item
            didx = numel(self(i).Data);

            try
                normalizedDataObj = normalizeSpectrum(self(i).Data(didx));

                if (overwrite == true)
                    self(i).Data(didx) = normalizedDataObj;
                else
                    newDescription = "Normalize";
                    self(i).addSpecData(newDescription, normalizedDataObj.XData, normalizedDataObj.YData);
                end

            catch
                warning('Could not normalize spectral data.');
            end

        end
    end
end