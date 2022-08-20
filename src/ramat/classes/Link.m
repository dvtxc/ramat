classdef Link < handle & matlab.mixin.indexing.RedefinesDot & matlab.mixin.Copyable
    %LINK Links analysis element to datacontainer
    %   This class will link to one or more DataContainers. All calls (dot
    %   references) will be forwarded. It adds three methods: moveup,
    %   movedown, and remove().

    properties
        target DataContainer = DataContainer.empty;
        parent AnalysisGroup = AnalysisGroup.empty;
        name string;
    end

    properties (Dependent)
        display_name string;
    end

    % Cached properties, in case target gets deleted.
    properties (Access = private)
        cached_display_name string;
    end

    properties (Dependent)
        idx uint8;
    end

    methods
        function self = Link(target, parent)
            %LINK Construct an instance of this class (Link)
            
            self.target = target;
            self.parent = parent;

            self.cached_display_name = target.display_name;
        end
    end

    methods (Access=protected)
        % Forward dot reference
        % Python-equivalent: __call__ method
        function varargout = dotReference(self,indexOp)
            [varargout{1:nargout}] = self.target.(indexOp);
        end

        function self = dotAssign(self,indexOp,varargin)
            [self.target.(indexOp)] = varargin{:};
        end
        
        function n = dotListLength(self,indexOp,indexContext)
            
            % Strategy when target has been deleted
            if ~isempty(self.target)
                if ~isvalid(self.target)
                    self.target = DataContainer.empty();
                else
                    self.cached_display_name = self.target.display_name;
                end
            end

            n = listLength(self.target,indexOp,indexContext);
        end
    end

    methods
        function displayname = get.display_name(self)

            if isempty(self.target), self.get_deleted_name(); return; end
            if ~isvalid(self.target), self.get_deleted_name(); return; end

            if self.name ~= ""
                displayname = self.name;
                return;
            end

            displayname = self.target.display_name;
            self.cached_display_name = self.target.display_name;
            
        end

        function displayname = get_deleted_name(self)

            displayname = "(DELETED) " + self.cached_display_name;
            
        end

        function idx = get.idx(self)
            %IDX Get index of group
            if isempty(self.parent), return; end
            idx = find(self == self.parent.children);
        end

        function moveup(self)
            %MOVEUP Move group up one place

            % Cannot move up from 1st place
            if self.idx == 1, return; end

            % Move by swapping with previous sibling
            swapidx = [self.idx - 1, self.idx];
            self.parent.children(swapidx) = self.parent.children(fliplr(swapidx));
        end

        function movedown(self)
            %MOVEDOWN Move group down one place
            
            % Cannot move down from last place
            if self.idx == numel(self.parent.children), return; end

            % Move by swapping with previous sibling
            swapidx = [self.idx + 1, self.idx];
            self.parent.children(swapidx) = self.parent.children(fliplr(swapidx));
        end

        function remove(self)
            %REMOVE Soft Destructor

            % Unset at parent
            self.parent.children(self.parent.children == self) = [];

            % Destruct
            self.delete();

        end

    end
end