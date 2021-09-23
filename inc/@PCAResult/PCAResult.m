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
    
    properties (Dependent)
        NumGroups;
        NumDataPoints;
        Range;
        Description;
    end
    
    methods
        function self = PCAResult(coefs, score, variance)
            %PCARESULT Construct an instance of this class
            
            self.Name = "";
            
            self.Coefs = coefs;
            self.Score = score;
            self.Variance = variance;
        end
        
        % Method Signatures
        scoresscatter(self, pcax);
        plotLoadings(self, pcax);
        
        % Methods
        function desc = get.Description(self)
            desc = vertcat(...
                sprintf( "Name:   %s", self.DisplayName ), ...
                sprintf( "Range:  %.1f - %.1f", self.Range(1), self.Range(2) ), ...
                sprintf( "Groups: %.0f", self.NumGroups ), ...
                sprintf( "Points: %.0f", self.NumDataPoints ) );
        end
        
        function numgroups = get.NumGroups(self)
            % Get the number of groups
            numgroups = length(self.SrcData);
        end
        
        function numdatapoints = get.NumDataPoints(self)
            % Get the number of data points
            sizes = size(self.Score);
            numdatapoints = sizes(1);
        end
        
        function range = get.Range(self)
            % Get the number of data points
            range = [min(self.CoefsBase), max(self.CoefsBase)];
        end
            
        
    end
end

