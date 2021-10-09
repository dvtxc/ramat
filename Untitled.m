indices = find(pcan.Score(:, 1) > 0);
rightspec = SpecData.empty();

j = 1;
for i = 1: length(pcan.SrcData)
    l = pcan.SrcData(i).GroupSize;
    groupindices = indices( indices<=l );
    rightspec = [rightspec; pcan.SrcData(i).GroupChildren(groupindices)];
    indices = indices - l;
    indices(indices<=0) = [];
end

%ydat = horzcat(rightdc.YData);
%ydat = mean(ydat,2);

% sp = SpecData( "right spectra", rightspec(1).Graph, permute( ydat, [3 2 1] ) );
% sp.Description = "right spectra";

%%
dchfp = DataContainer.empty();

for i = 1:length(sphfp)
    dchfp(i) = DataContainer();
    dchfp(i).Name = sphfp(i).Name;
    dchfp(i).appendSpecData( sphfp(i) );
end

dchfp = dchfp(:);