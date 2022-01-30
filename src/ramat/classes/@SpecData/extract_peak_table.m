function peak_table = extract_peak_table(self, options)
    % EXTRACT_PEAK_TABLE Finds peaks and adds extracted peak table
    %   This is a wrapper function for FIND_PEAKS.

    arguments
        self SpecData;
        options.min_prominence = 0.1;
    end

    % To pass options kwargs, convert to struct to cell
    if ~isempty(options)
        options = namedargs2cell(options);
    else
        options = cell.empty();
    end

    peak_table = [];

    if ~isvalid(self) || isempty(self)
        % Handle to deleted object?
        return
    end

    % Find peaks
    peak_table = self.find_peaks(options{:});

    % Append extracted peak table
    self.PeakTable = peak_table;
    self.append_sibling(peak_table);

end