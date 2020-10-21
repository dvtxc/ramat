function out = importSingleWIP(varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if (nargin == 2 && ~isempty(varargin{2}))
    guiOut = varargin{2};
end
if (nargin == 0)
    return
end

fullFileName = varargin{1};

%% Check whether WITIO reader is activated
if ~witio_isenabled()
    %enableWITIO();
end

% Make sure all helper files of the WITIO module are in the MATLAB path.
enableWITIOhelper();

%% Import .wip file
[O_wid, O_wip, ~] = wip.read('X:\121250_PolyKARD\5-Data\02_Raman\WIP Files\20200710_RC02 and RC03.wip','-all');

% Output to out=[]
out = [];
f = 1;

% Default: import everything
for i = 1:len(O_wid)
    out(f) = importSingleWIData(O_wid(f, 1));
end

end

