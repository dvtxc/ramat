%% Run initialisation
init;

%% Start gui

% Pack initial data
initVar = struct();
initVar.rootdir = rootdir;
initVar.witio_status = witio_status;
initVar.prj = prj;

% Run main app
fprintf('Starting GUI.\n');
global app;
app = ramatguiapp(initVar);