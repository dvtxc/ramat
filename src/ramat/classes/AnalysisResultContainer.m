classdef AnalysisResultContainer < Container
    %AnalysisResultContainer Contains DataItems that are part of an 
    %analysis result
    %   Similar to DataContainer, but contains DataItems that are part of
    %   an analysis result, e.g. PCAResult and extracted information.

    properties
    end

    properties (Dependent)
    end

    methods
        function self = AnalysisResultContainer(prj, name, parent)
            %ANALYSISRESULTCONTAINER Constructor
            
            arguments
                prj Project = Project.empty();
                name string = "";
                parent Group = Group.empty();
            end

            % New container should have project parent, otherwise it might
            % not be saved.
            if isempty(prj)
                throw(MException('Ramat:validation', 'New analysis container does not have project parent.'));
            end

            % Set to root group, if no group is provided.
            if isempty(parent)
                parent = prj.get_analysis_result_root();
            end

            self.project_parent = prj;
            self.name = name;
            self.parent = parent;

        end

    end

    methods
    end
end