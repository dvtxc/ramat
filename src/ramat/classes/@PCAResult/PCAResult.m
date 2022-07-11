classdef PCAResult < DataItem
    %PCARESULT Contains results of PCA
        
    properties
        Coefs double;                  % Coefficients
        Score double;                  % Scores
        Variance double;
        SrcData struct = struct();     % Source Data
        source Analysis = Analysis.empty();
        CoefsBase double;              % Spectral Base for loadings plot of the coefficients
        DataSizes;
        dataType = "PCA";
        Type = "PCA";
    end
    
    properties (Dependent)
        NumGroups;
        NumDataPoints;
        Range;
    end
    
    methods
        function self = PCAResult(coefs, score, variance, parent)
            %PCARESULT Construct an instance of this class

            arguments
                coefs double;
                score double;
                variance double;
                parent AnalysisResultContainer = AnalysisResultContainer.empty();
            end
            
            self.Name = "";
            
            self.Coefs = coefs;
            self.Score = score;
            self.Variance = variance;
            self.parent_container = parent;

            self.description = self.generate_description();
        end
        
        % Method Signatures
        scoresscatter(self, pcax);
        plotLoadings(self, pcax);
        
        % Methods
        function desc = generate_description(self)
            % Generate a simple description of the PCA analysis

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

