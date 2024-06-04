function remodel(remodel_args)
% Run the remodeling tools.
% 
% Parameters:
%    remodel_args  - A cell array of command line parameters for
%    remodeling.
%
    py.importlib.import_module('hed');
    py.hed.tools.remodeling.cli.run_remodel.main(remodel_args);
  
