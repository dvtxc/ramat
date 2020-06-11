function plotpca(score,pcax,axPercentage,groupingTable)

groupLengths = uint32(groupingTable.Fun_nSpectra);
nGroups = height(groupingTable);

f = figure;
ax = axes('Parent',f);

co = get(gca,'ColorOrder');
hold on
j = 1;
for i = 1:nGroups
    l = groupLengths(i);
    
    scatter(score(j:l+j-1, pcax(1)), ...
        -score(j:l+j-1, pcax(2)), ...
        45, co(i,:), 'filled');
    
    
    
    j = j + l;
end

% Set Axes
xlabelText = sprintf('PC%u: %.2g%%',pcax(1),axPercentage(pcax(1)));
ylabelText = sprintf('PC%u: %.2g%%',pcax(2),axPercentage(pcax(2)));
xlabel(xlabelText,'FontWeight','bold');
ylabel(ylabelText,'FontWeight','bold');
set(ax,'FontSize',14);
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

% Set Legend
groupNames = groupingTable.GroupName;
legend(ax,groupNames);


hold on
j = 1;
for i = 1:nGroups
    l = groupLengths(i);
    
    error_ellipse(score(j:l+j-1, pcax(1)), ...
        -score(j:l+j-1, pcax(2)), ...
        co(i,:));
    j = j + l;
end

end
%%

%n = 1; l=82; error_ellipse(score(n:l+n-1,pcax(1)),-score(n:l+n-1,pcax(2)));
%n = l+n; l=156; error_ellipse(score(n:l+n-1,pcax(1)),-score(n:l+n-1,pcax(2)));
% n = l+n; l=7; error_ellipse(score(n:l+n-1,pcax(1)),-score(n:l+n-1,pcax(2)));
% n = l+n; l=4; error_ellipse(score(n:l+n-1,pcax(1)),-score(n:l+n-1,pcax(2)));

% n = l+n; l=4; error_ellipse(score([6:17],pcax(1)),-score([6:17],pcax(2)));

