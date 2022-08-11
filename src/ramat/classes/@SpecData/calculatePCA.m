function pcaresult = calculatePCA(self, range)
    %CALCULATEPCA Calculate principle component analysis (PCA) of an array
    %of spectral data objects
    %
    %   Input
    %       self:   (mx1) array of SpecData
    %       range:  (2x1) double

    arguments
        self;
        range double = [];
    end
       
    % Prepare data

    if ~isempty(range)
        % Calculate PCA of a specific range
        startG = range(1);
        endG = range(2);
        
        % Create a trimmed SpecData() as a copy.
        tmpdat = trim_spectrum(copy(self), startG, endG);
        graphBase = tmpdat.graph;            
        
        flatdata = horzcat(tmpdat.FlatDataArray);
        
        % Free up memory
        delete(tmpdat);
        clear tmpdat
        
    else
        % Use the full range
        
        flatdata = horzcat(self.FlatDataArray);
        graphBase = self.graph;
        
    end
    
    % Remove NaN-Spectra
    flatdata( :, all(isnan(flatdata))) = [];
    
    inputdata = transpose(flatdata);

    % Calculate PCA
    [coefs, score, ~, ~, variance] = pca(inputdata);
    
    % Return results as an PCAResult Object
    pcaresult = PCAResult(graphBase, coefs, score, variance);

end

