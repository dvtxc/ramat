function scoresscatter(pcaresult, pcax)
%SCORESSCATTER
%   Draw a scatter plot of the scores of the PCA Data along 2 principal
%   components (2D PCA)
%   pcaresult:  PCAResult() object
%   pcax:       2x1 integer array with the principal component axis numbers

    if isempty(pcaresult.SrcData)
        % We need a grouping table to create a legend.
        
        num_spectra = size(pcaresult.Score, 1);
        pcaresult.SrcData.GroupName = "Ungrouped";
        pcaresult.SrcData.GroupSize = num_spectra;

    end
        
    groupLengths = vertcat(pcaresult.SrcData.GroupSize);
    nGroups = numel(pcaresult.SrcData);
    
    f = figure;
    ax = axes('Parent',f);
    
    % Get standard MATLAB plot colors
    co = get(gca,'ColorOrder');
    hold on
    
    % Scatter Handles
    s = [];
    
    j = 1; % Score Index
    for i = 1:nGroups
        l = groupLengths(i);
        
        % Color for current item
        coidx = mod(i - 1, 6 ) + 1;
        color = co(coidx, :);

        % Plot scatter for every group
        % Invert Y-axis for compatibility with PCA function of ORIGIN.
        s(i) = scatter( ...
            pcaresult.Score(j:l+j-1, pcax(1)), ... % x-axis
            -pcaresult.Score(j:l+j-1, pcax(2)), ...% inv. y-axis
            45, ...                                 % size
            color, ...                              % color
            'filled');                              % marker type
        
        % Plot confidence ellipses
        error_ellipse( ...
            pcaresult.Score(j:l+j-1, pcax(1)), ...
            -pcaresult.Score(j:l+j-1, pcax(2)), ...
            color);
        
        % Fast-forward in scores array by group length.
        j = j + l;
    end

    % Set Axes
    xlabelText = sprintf('PC%u: %.2g%%', pcax(1), pcaresult.Variance(pcax(1)));
    ylabelText = sprintf('PC%u: %.2g%%', pcax(2), pcaresult.Variance(pcax(2)));
    xlabel(xlabelText,'FontWeight','bold');
    ylabel(ylabelText,'FontWeight','bold');
    set(ax,'FontSize',14);
    ax.XAxisLocation = 'bottom';
    ax.YAxisLocation = 'left';

    % Set Legend
    groupNames = vertcat(pcaresult.SrcData.GroupName);
    legend(s,groupNames);


end

