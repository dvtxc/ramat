classdef (Abstract) SpecDataABC < DataItem
    %SPECDATAABC Abstract Base Class (ABC) for spectral data
    %   This class is a abstract base class for classes that store spectral
    %   data.
    %
    %   Child classes:
    %       SpectrumSimple  Simple static, non-spatial spectral data
    %       SpecData        Full spectral data
    %   
    %   Parent Class: DataItem
    %
    %   Properties inherited from parent class "DataItem":
    %       name        string
    %       description string
    %       parent      DataContainer
    %       Type        string

    properties (Abstract)
        % Spectral data, must have concrete implementation
        data;
    end
    
    properties      
        % Spectral Data
        data_unit string;
        
        % Spectral Base
        graph double;
        graph_unit string;
        
        % PeakTable
        peak_table = PeakTable.empty();
    end
    
    properties (Access = public, Dependent)
        GraphSize;
    end
    
    properties (SetAccess = private)
        Type = "SpecData";
    end

    % Signatures
    methods
        peak_table = add_peak_table(self, options);
        peak_table = gen_peak_table(self, options);
    end
    
    methods

        function idx = wavnumtoidx(self, wavnum)
            % WAVNUMTOIDX Convert wavenumbers to indices
            
            if numel(wavnum) == 1
                idx = find(self.graph > wavnum, 1, 'first');
            elseif numel(wavnum) == 2
                startIdx = find(self.graph > wavnum(1), 1, 'first');
                endIdx = find(self.graph < wavnum(2), 1, 'last');
                
                idx = [startIdx, endIdx];
            end
            
        end
        
        % DEPENDENT PROPERTIES
        function wavres = get.GraphSize(self)
            % Returns size or wave resolution of the spectral graph
            wavres = size(self.graph, 1);
        end

        function preview_peak_table(self, options)
            %PREVIEW_PEAK_TABLE

            arguments
                self
                options.Axes = [];
                options.min_prominence = 0.1;
                options.negative_peaks = false;
            end

            peaktable = self.gen_peak_table(min_prominence=options.min_prominence, negative_peaks=options.negative_peaks);

            if isempty(peaktable)
                warning("No peak table was extracted.");
                return;
            end

            peaktable.plot(Axes = options.Axes);
            
        end

        function add_context_actions(self, cm, node, app)
            %ADD_CONTEXT_ACTIONS Retrieve all (possible) actions for this
            %data item that should be displayed in the context menu
            %   This function adds menu items to the context menu, which
            %   link to specific context actions for this data item.
            %
            arguments
                self;
                cm matlab.ui.container.ContextMenu;
                node matlab.ui.container.TreeNode;
                app ramatguiapp;
            end

            % Get parent actions of DataItem
            add_context_actions@DataItem(self, cm, node, app);

            % Get specific context actions for SpecDataABC
            opts.min_prom = app.MinimumProminenceEditField.Value;
            opts.neg_peaks = app.PeakAnalysisNegativeCheckbox.Value;

            menu_item = uimenu(cm, ...
                Text="Peak Analysis");
            m1 = uimenu(menu_item, ...
                Text="Preview Peak Analysis (min_prom: " + string(opts.min_prom) + ")", ...
                MenuSelectedFcn={@preview, self, opts});
            m2 = uimenu(menu_item, Text="Extract Peak Table (min_prom: " + string(opts.min_prom) + ")", ...
                MenuSelectedFcn={@extract, self, app, opts});

            function preview(~, ~, self, opts)
                self.preview_peak_table(min_prominence=opts.min_prom, negative_peaks=opts.neg_peaks);
            end

            function extract(~, ~, self, app, opts)
                self.add_peak_table(min_prominence=opts.min_prom, negative_peaks=opts.neg_peaks);
                update_data_items_tree(app, self.parent_container);
            end

        end
        
    end
end

