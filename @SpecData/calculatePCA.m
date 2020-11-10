function pcaresult = calculatePCA(self)
    %CALCULATEPCA
    
    
%     try
        inputdata = horzcat(self.FlatDataArray);
%     catch
%         warning('Could not concatenate Dat');
    
    % Calculate PCA
    [coefs, score, ~, ~, variance] = pca(inputdata);
    
    % Return results as an PCAResult Object
    pcaresult = PCAResult(coefs, score, variance);
end

