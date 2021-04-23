classdef PCAResult < AnalysisResult
    %PCARESULT Contains results of PCA
        
    properties
        Coefs;                  % Coefficients
        Score;                  % Scores
        Variance;
        SrcData = struct();     % Source Data
        CoefsBase;              % Spectral Base for loadings plot of the coefficients
        DataSizes;
        dataType = "PCA";
    end
    
    methods
        function self = PCAResult(coefs, score, variance)
            %PCARESULT Construct an instance of this class
            
            self.Name = "";
            
            self.Coefs = coefs;
            self.Score = score;
            self.Variance = variance;
        end
        
        
        scoresscatter(self, pcax);
        
    end
end

