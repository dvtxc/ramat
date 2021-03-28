function dataObject = importSingleWIData(widO)
% IMPORTSINGLEWIDATA parses a WID object (widO) into RAMAT objects.

% Create a DataContainer object
dataObject = DataContainer();
item_name = widO.Name;
dataObject.Name = item_name;

fprintf('\n%s\n', dataObject.DisplayName);

switch widO.Type
    case 'TDGraph'
        %% RAW DATA
        excitation_wavlen = widO.Info.GraphInterpretation.Data.TDSpectralInterpretation.ExcitationWaveLength;
              
        % Raw Data, as imported.
        specdat = SpecData( ...
            item_name, ...
            widO.Info.Graph, ...
            widO.Data, ...
            widO.Info.GraphUnit, ...
            widO.Info.DataUnit);
        
        specdat.ExcitationWavelength = excitation_wavlen;
        specdat.Description = "Raw Data";
        
        switch widO.SubType
            case 'Point'
                fprintf('## Single Spectrum\n');
            case 'Image'
                fprintf('## %i x %i Area Scan\n', specdat.XSize, specdat.YSize);
        end
        
        % Append raw (=as-is) spectral data to DataContainer
%         dataObject.appendSpecData(specdat);
        
        %% PROCESSED DATA
        % Process data
        
        gunit = widO.Info.GraphUnit;
        
        switch gunit
            case 'Raman Shift (rel. 1/cm)'
                gdata = widO.Info.Graph;
            case 'Nanometers (nm)'
                gdata = (1./excitation_wavlen - 1./ widO.Info.Graph) .* 1e7;
            otherwise
                error('Could not read graph unit for %s', widO.Name);
        end
        
        
        % Convert to double and store in correct order
        data = double(widO.Data);
        data = permute(data, [2 1 3]);
        
        specdat = SpecData( ...
            item_name, ...
            gdata, ...
            data, ...
            widO.Info.GraphUnit, ...
            widO.Info.DataUnit);
        
        specdat.ExcitationWavelength = excitation_wavlen;
        specdat.Description = "Imported Data";
        
        % Trim Data?
        % specdat_obj.trimData(trimStart, trimEnd)
        
        % Remove Offset
%         fprintf('-- Removing Offset ...\n');
%         specdat = specdat.removeConstantOffset();
        
        % Remove Background
%         fprintf('-- Removing Baseline ...\n');
%         specdat = specdat.removeBaseline();
        
        % Normalize Data
%         fprintf('-- Normalising Spectrum ...\n');
%         specdat = specdat.normalizeSpectrum();
        
        dataObject.appendSpecData(specdat)
        
    case 'TDText'
        fprintf('## Text File\n');
        
    case 'TDImage'
        fprintf('## Image\n');
        
end
        
end

