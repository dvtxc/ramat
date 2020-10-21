function enableWITIOhelper()

if witio_isenabled()
    % Check if helper functions can be found
    if ~exist('varargin_dashed_str_inds')     
        [dir, ~, ~] = fileparts(which('wit_io_license'));
        helperdir = [dir, '\helper'];
        addpath(genpath(helperdir));
    end
end

end