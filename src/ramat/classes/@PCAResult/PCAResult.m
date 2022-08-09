classdef PCAResult < DataItem
    %PCARESULT Contains results of PCA
    %
    %   Parent Class: DataItem
    %
    %   Properties inherited from parent class "DataItem":
    %       name                string
    %       description         string
    %       parent_container    Container
    %       Type                string  (private)
        
    properties
        Coefs double;                           % Coefficients
        Score double;                           % Scores
        Variance double;
        SrcData struct = struct();              % Source Data
        source Analysis = Analysis.empty();
        CoefsBase double = [0 1];               % Spectral Base for loadings plot of the coefficients
        DataSizes;
        dataType = "PCA";
    end

    properties (SetAccess=private)
        Type = "PCA";
    end
    
    properties (Dependent)
        NumGroups;
        NumDataPoints;
        Range;
    end
    
    methods
        function self = PCAResult(coefsbase, coefs, score, variance, parent)
            %PCARESULT Construct an instance of this class

            arguments
                coefsbase double;
                coefs double;
                score double;
                variance double;
                parent AnalysisResultContainer = AnalysisResultContainer.empty();
            end
            
            self.name = "";
            self.parent_container = parent;
            
            self.CoefsBase = coefsbase;
            self.Coefs = coefs;
            self.Score = score;
            self.Variance = variance;

            self.description = self.generate_description();
                        
        end
        
        % Method Signatures
        scoresscatter(self, pcax);
        plotLoadings(self, pcax);
        
        % Methods
        function desc = generate_description(self)
            % Generate a simple description of the PCA analysis

            desc = vertcat(...
                sprintf( "Name:   %s", self.name ), ...
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

        function ax = plot(self, kwargs)
            %PLOT Default plotting function of PCAResult

            arguments
                self;
                kwargs.Axes = [];
                kwargs.PCs uint8 = [1 2];
            end

            ax = [];

            pcax = kwargs.PCs;
            self.scoresscatter(pcax, Axes=kwargs.Axes);

        end
            
        
    end
end

