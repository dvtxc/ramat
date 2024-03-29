function dataObject = import_single_widata(widO, kwargs)
    % IMPORT_SINGLE_WIDATA parses a WID object (widO) into RAMAT objects.

    arguments
        widO;
        kwargs.retain_original = false;
        kwargs.normalize = false;
        kwargs.remove_offset = false;
        kwargs.remove_baseline = false;
        kwargs.remove_baseline_opts struct = [];
        kwargs.gui = [];
        kwargs.processing = get_processing_options;
    end

    % Python-like kwargs unpacking
    %kwargs = unpack(kwargs);
    
    % Create a DataContainer object
    dataObject = DataContainer();
    item_name = widO.Name;
    dataObject.Name = item_name;
    
    out(sprintf('\n%s', dataObject.DisplayName), gui=kwargs.gui);
    
    % Append data item to data container based on data type
    switch widO.Type
        case 'TDGraph'
            
            % Display dimensions
            switch widO.SubType
                case 'Point'
                    out(sprintf('## Single Spectrum'), gui=kwargs.gui);
                case 'Image'
                    out(sprintf('## %i x %i Area Scan', widO.Info.XLength, widO.Info.YLength), gui=kwargs.gui);
            end

            % Excitation wavelength
            excitation_wavlen = widO.Info.GraphInterpretation.Data.TDSpectralInterpretation.ExcitationWaveLength;

            % Convert to double and store in correct order
            data = double(widO.Data);
            data = permute(data, [2 1 3]);

            % Graph unit
            graph_unit = widO.Info.GraphUnit;
            
            %% RAW DATA
            
            % Keep copy of original data
            if kwargs.processing.retain_original
                if any(kwargs.processing.remove_offset, kwargs.processing.remove_baseline, kwargs.processing.normalize)

                    % Create SpecData instance
                    specdat = SpecData( ...
                        name=item_name, ...
                        graphbase=widO.Info.Graph, ...   
                        data=data, ...
                        graphunit=graph_unit, ...
                        dataunit=widO.Info.DataUnit);
                    
                    % Add additional info
                    specdat.ExcitationWavelength = excitation_wavlen;
                    specdat.Description = "Raw Data";
             
                    % Append raw (=as-is) spectral data to DataContainer
                    dataObject.appendDataItem(specdat);

                end
            end
            
            %% PROCESSED DATA
            % Process data
            
            % Convert graph units if necessary
            switch graph_unit
                case 'Raman Shift (rel. 1/cm)'
                    graph_data = widO.Info.Graph;
                case 'Nanometers (nm)'
                    graph_data = (1./excitation_wavlen - 1./ widO.Info.Graph) .* 1e7;
                otherwise
                    error('Could not read graph unit for %s', widO.Name);
            end
                        
            
            % Create SpecData Object
            specdat = SpecData( ...
                item_name, ...
                graph_data, ...
                data, ...
                graph_unit, ...
                widO.Info.DataUnit);
            
            specdat.ExcitationWavelength = excitation_wavlen;
            specdat.Description = "Imported Data";
            
            % Store meta information
            specdat.X = widO.Info.X;
            specdat.Y = widO.Info.Y;
            specdat.Z = widO.Info.Z;
            
            % Trim Data?
            % specdat_obj.trimData(trimStart, trimEnd)
            
            % Remove Offset
            if kwargs.processing.remove_offset
                out('-- Removing Offset ...', gui=kwargs.gui);
                specdat.removeBaseline('constant');
            end
            
            % Remove Background
            if kwargs.processing.remove_baseline
                out('-- Removing Baseline ...', gui=kwargs.gui);
                specdat.removeBaseline();
            end
            
            % Normalize Data
            if kwargs.processing.normalize
                out('-- Normalising Spectrum ...', gui=kwargs.gui);
                specdat.normalizeSpectrum();
            end
            
            % Append SpecData to Data Container
            dataObject.appendDataItem(specdat);
            
        case 'TDText'
            out('## Text File', gui=kwargs.gui);
            
            textdat = TextData(item_name, widO.Data);
            textdat.Description = "Imported Text";
            
            % Append to data container
            dataObject.appendDataItem(textdat);
            
        case 'TDBitmap'
            out('## Image', gui=kwargs.gui);
            
            imgdat = ImageData(item_name, widO.Data);
            imgdat.Description = "Imported Image";
            
            % Append to data container
            dataObject.appendDataItem(imgdat);
            
    end
        
end

