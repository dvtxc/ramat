function peak_table = find_peaks(self, options)
    % FIND_PEAKS

    arguments
        self SpecData;
        options.min_prominence = 0.1;
    end

    peak_table = [];

    % Check if the signal processing toolbox is installed
    if exist('findpeaks') == 0
        warning("Function findpeaks() does not exist. Is the Signal Processing Toolbox installed?");
        return
    end
    
    if ~isvalid(self) || isempty(self)
        % Handle to deleted object?
        return
    end

    xdata = self.Graph;
    ydata = self.FlatDataArray;

    range = max(ydata) - min(ydata);

    % Calculate absolute prominence
    abs_min_prominence = options.min_prominence * range;

    % Find peaks
    [peaks, locations] = findpeaks(ydata, xdata, MinPeakProminence=abs_min_prominence);

    % Create PeakTable
    peak_table = PeakTable(peaks, locations, self, "PeakTable");

    % Store used options to find peaks
    peak_table.min_prominence = options.min_prominence;
end