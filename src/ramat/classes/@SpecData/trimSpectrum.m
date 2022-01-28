function self = trimSpectrum(self, startG, endG)
    % Trims spectral data to [startG, endG]
    % startG and endG should be provided in the graph units, ie. if
    % graph units are given in 1/cm, the trim limits should be in
    % the same units.

    arguments
        self;
        startG;
        endG;
    end

    if (endG > startG)
        % Trim Region is valid

        for i = 1:numel(self)
            % Repeat operation for each spectral data object

            gdat = self(i).Graph;
            dat = self(i).Data;

            % Find indices of trim region
            startIdx = find(gdat > startG, 1, 'first');
            endIdx = find(gdat < endG, 1, 'last');

            self(i).Graph = gdat( startIdx:endIdx , :);
            self(i).Data = dat(:, :, startIdx:endIdx);
        end
    else
        warning('Trim region is invalid. Second values should be greater than the first value.');
    end
end