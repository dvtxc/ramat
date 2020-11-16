function pcaresult = calculatePCA(self)
    %CALCULATEPCA
    
    
    try
        inputdata = transpose(horzcat(self.FlatDataArray));
    catch
        error('Could not prepare data for PCA');
    end
    
    % Calculate PCA
    [coefs, score, ~, ~, variance] = pca(inputdata);
    
    % Return results as an PCAResult Object
    pcaresult = PCAResult(coefs, score, variance);
end

