%% Initialisation

% Get dir of the executable
global rootdir;
rootdir = GetExecutableFolder();

% Add subfolders
addpath('inc');
addpath(fullfile('inc','gui'));
addpath(fullfile('inc','gui','images'));
addpath(fullfile('inc','gui','wit_icons'));
addpath(fullfile('inc','gui','guihelper'));
addpath(fullfile('inc','algo'));
addpath('helper');
addpath(fullfile('helper', 'io'));

% Check if WITIO redist is enabled
[witio_status, ~] = witio_isenabled();
if ~witio_status
    fprintf('WARNING: The WITIO reader is not enabled. This is required to read WITec project files.');
else
    fprintf('WITIO reader found.\n');
end

% Create new empty project
global prj;
prj = Project();

%% Start gui

% Pack initial data
initVar = struct();
initVar.rootdir = rootdir;
initVar.witio_status = witio_status;
initVar.prj = prj;

% Run main app
fprintf('Starting GUI.\n');
app = ramatgui(initVar);

%% Functions

% Returns the folder where the compiled executable actually resides.
% If running in the development environment, it returns the Current Folder,
% Which may not be the same as where the code is saved because MATLAB doesn't always
% ask the user if they want to Change Folder if the user is running the m-file with the current folder
% being different than the m-file's folder.
function executableFolder = GetExecutableFolder() 
	try
		if isdeployed 
			% User is running an executable in standalone mode. 
			[status, result] = system('set PATH');
			executableFolder = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));
		else
			% User is running an m-file from the MATLAB integrated development environment (regular MATLAB).
			executableFolder = pwd; 
		end 
	catch ME
		errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
			ME.stack(1).name, ME.stack(1).line, ME.message);
		uiwait(warndlg(errorMessage));
	end
	return;
end