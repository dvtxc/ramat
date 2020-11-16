function pcaresult = calculatePCA(self)
    %CALCULATEPCA
    
    
    try
        flatdata = horzcat(self.FlatDataArray);
        flatdata( :, all(isnan(flatdata))) = [];
        
        inputdata = transpose(flatdata);
    catch
        error('Could not prepare data for PCA');
    end
    
    % Calculate PCA
    [coefs, score, ~, ~, variance] = pca(inputdata);
    
    % Return results as an PCAResult Object
    pcaresult = PCAResult(coefs, score, variance);
end

