function newDirs = filterDirectories(dirs, excludeDirs)
% Returns a filtered list of fullpaths of directories not in excludeDirs
%
% Parameters:
%   dirs (cell array):   List of fullpaths of directories to check.
%   excludeDirs (cell array):  List of fullpaths of directories to exclude.
%
%   Returns:
%      cell array:  list of fullpaths of directories not excluded.
%
    if ~iscell(dirs) || ~iscell(excludeDirs)
        error('MATLAB:cellRefFromNonCell', ...
        'dirs and excludeDirs must be cell arrays')
    end
    dirMask = false(length(dirs), 1);
    for k = 1:length(dirs)
        if ~ismember(dirs{k}, excludeDirs)
            dirMask(k) = true;
        end
    end
    newDirs = dirs(dirMask);
end