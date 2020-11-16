classdef PCAResult
    %PCARESULT Contains results of PCA
        
    properties
        Coefs;
        Score;
        Variance;
        Groups;
    end
    
    methods
        function self = PCAResult(coefs, score, variance)
            %PCARESULT Construct an instance of this class
            
            self.Coefs = coefs;
            self.Score = score;
            self.Variance = variance;
        end
        
        
        scoresscatter(self, pcax);
        
    end
end

