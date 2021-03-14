function scoresscatter(pcaresult, pcax)
%SCORESSCATTER
%   Draw a scatter plot of the scores of the PCA Data along 2 principal
%   components (2D PCA)
%   pcaresult:  PCAResult() object
%   pcax:       2x1 integer array with the principal component axis numbers

    if isempty(pcaresult.Groups)
        % We need a grouping table to create a legend.
        num_spectra = size(pcaresult.Score, 1);
        pcaresult.Groups = table( ...
            {'Ungrouped'}, num_spectra, ...
            'VariableNames', {'group_name', 'num_spectra'});
    end
        
    groupLengths = uint32(pcaresult.Groups.num_spectra);
    nGroups = height(pcaresult.Groups);
    
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

        % Plot scatter for every group
        % Invert Y-axis for compatibility with PCA function of ORIGIN.
        s(i) = scatter( ...
            pcaresult.Score(j:l+j-1, pcax(1)), ... % x-axis
            -pcaresult.Score(j:l+j-1, pcax(2)), ...% inv. y-axis
            45, ...                                 % size
            co(i,:), ...                            % color
            'filled');                              % marker type
        
        % Plot confidence ellipses
        error_ellipse( ...
            pcaresult.Score(j:l+j-1, pcax(1)), ...
            -pcaresult.Score(j:l+j-1, pcax(2)), ...
            co(i,:));
        
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
    groupNames = pcaresult.Groups.group_name;
    legend(s,groupNames);


end
%%

%n = 1; l=82; error_ellipse(score(n:l+n-1,pcax(1)),-score(n:l+n-1,pcax(2)));
%n = l+n; l=156; error_ellipse(score(n:l+n-1,pcax(1)),-score(n:l+n-1,pcax(2)));
% n = l+n; l=7; error_ellipse(score(n:l+n-1,pcax(1)),-score(n:l+n-1,pcax(2)));
% n = l+n; l=4; error_ellipse(score(n:l+n-1,pcax(1)),-score(n:l+n-1,pcax(2)));

% n = l+n; l=4; error_ellipse(score([6:17],pcax(1)),-score([6:17],pcax(2)));

