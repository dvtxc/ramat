classdef PCAResult
    %PCARESULT Contains results of PCA
        
    properties
        Coefs;
        Score;
        Variance;
    end
    
    methods
        function self = PCAResult(coefs, score, variance)
            %PCARESULT Construct an instance of this class
            
            self.Coefs = coefs;
            self.Score = score;
            self.Variance = variance;
        end
        
    end
end

