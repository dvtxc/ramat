classdef Project < handle
    %PROJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DataSet = DataContainer.empty;
        GroupSet = Group.empty;
        AnalysisSet = Analysis.empty;
        ActiveAnalysis = Analysis.empty;
        ActiveAnalysisResult = AnalysisResult.empty;
        Name = "";
        AnalysisResults; %OLD
        analysis_result_root Group = Group.empty; %New
        data_root Group = Group.empty; %New
    end
    
    methods
        function append_data(self, dataset, group)
            %APPEND_DATA:
            %   Appends a dataset to the project object

            arguments
                self;
                dataset;
                group = Group.empty();
            end

            self.DataSet = [self.DataSet; dataset];
            
            % What group will it be appended to
            if isempty(group)
                % Create a new group for the newly appended data
                new_group = self.add_group("New Import");
            else
                new_group = group;
            end

            new_group.add_children(dataset);
            
            dataset.setgroup( new_group );
        end
        
        function new_group = add_group(self, groupname)
            %ADD_GROUP
            
            new_group = Group( self, groupname );
            self.GroupSet(end + 1) = new_group;
            
        end
        
        function newAnalysisHandle = add_analysis(self, dataset)
            %ADD_ANALYSIS
            %   Add a new data subset for analysis
            %   Returns:    handle to new analysis subset
            
            newAnalysisHandle = Analysis(self, dataset);
            self.AnalysisSet = [self.AnalysisSet; newAnalysisHandle];
        end
        
        function pcaresult = create_pca(self, options)
            % Create new PCA analysis
            
            arguments
                self Project
                options.Range = [];
                options.Selection (:,:) DataContainer = DataContainer.empty;
            end
            
            if ~isempty(self.AnalysisSet)
                if ~isempty(self.ActiveAnalysis)
                    % Found analysis subset to operate on
                    subset = self.ActiveAnalysis;
                    
                    pcaresult = subset.compute_pca(Range=options.Range, Selection=options.Selection);
                end
            end
        end
        
        function add_analysis_result(self, newresult)
            %ADD_ANALYSIS_RESULT
            
            self.AnalysisResults = [self.AnalysisResults; newresult];
        end
        
    end

    methods
        % Get root groups

        function root = get_analysis_result_root(self)
            root = self.analysis_result_root();
        end

        function root = get_data_root(self)
            root = self.data_root();
        end
    end
end

