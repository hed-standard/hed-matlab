% function [pyenvNew, pyenvOld] = setupPython(pythonPath, ...
%                                             venvPath, forceCreation)


venvPath = ['G:/HEDMATLAB/testProj' filesep 'venv'];
pyenvOld = pyenv;
forceCreation = false;
pythonPath = pyenvOld.Executable;
venvFull = fullfile(venvPath);
if exist(venvFull, 'dir') && ~forceCreation
    error('setupPython:venvExists', ...
          'Delete %s or set forceCreation to true', venvFull)
end

% pythonVirtual = [venvPath filesep]
% if
% if C:\Users\username\AppData\Local\Programs\Python\python -m venv C:\Users\username\py38 

[a, b] = system('"C:\Program Files\Python\Python39\Scripts\pip" install g:/HEDPython/hed-python')
 
%"Defaulting to user installation because normal site-packages is not writeable"
%C:\Users\Robbi\AppData\Roaming\Python\Python39\Scripts
% Have to restart MATLAB to get things to take into effect.

%py.importlib.import_module('hed')  says what is available.