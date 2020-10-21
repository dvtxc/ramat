function [status, identifier] = witio_isenabled()
% Checks whether the WITIO reader is enabled and all helper functions can
% be found.

installedAddons = matlab.addons.installedAddons;
witio_row = installedAddons(ismember(installedAddons.Name,'wit_io'),:);

if ~isempty(witio_row)
    % WITIO module is installed
    witio_row = witio_row(1,:);
    
    identifier = witio_row.Identifier;   
    status = matlab.addons.isAddonEnabled(identifier);
            
end

end