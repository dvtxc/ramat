function pcaresult = calculatePCA(self, range)
    %CALCULATEPCA
       
    % Prepare data
    try
        if nargin > 1
            % Calculate PCA of a specific range
            startG = range(1);
            endG = range(2);
            
            % Create a trimmed SpecData() as a copy.
            tmpdat = trimSpectrum(copy(self), startG, endG);
            graphBase = tmpdat.Graph;            
            
            flatdata = horzcat(tmpdat.FlatDataArray);
            
            % Free up memory
            delete(tmpdat);
            clear tmpdat
            
        else
            % Use the full range
            
            flatdata = horzcat(self.FlatDataArray);
            graphBase = self.Graph;
            
        end
        
        % Remove NaN-Spectra
        flatdata( :, all(isnan(flatdata))) = [];
        
        inputdata = transpose(flatdata);
    catch
        error('Could not prepare data for PCA');
    end
    
    % Calculate PCA
    [coefs, score, ~, ~, variance] = pca(inputdata);
    
    % Return results as an PCAResult Object
    pcaresult = PCAResult(coefs, score, variance);
    
    pcaresult.CoefsBase = graphBase;
end

