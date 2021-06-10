function tblOutput = calcGroupedAverage(tblInput)
% Collapses Table to Averaged Spectra

funcmean = @(x) {mean([x{:}], 2)};

tblOutput = varfun(funcmean, tblInput, ...
    'GroupingVariables', 'group', ...
    'InputVariables', {'xData','yData'});

tblOutput.Properties.VariableNames{3} = 'xData';
tblOutput.Properties.VariableNames{4} = 'yData';

% All groups now only contain one averaged spectrum.
tblOutput.nSpectra = ones(height(tblOutput), 1);

end