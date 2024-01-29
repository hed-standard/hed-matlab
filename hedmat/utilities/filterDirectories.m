function newDirs = filterDirectories(parentDir, dirs, excludeDirs)
% Returns a filtered list of fullpaths of directories not in excludeDirs
%
% Parameters:
%   parentDir (string):  The fullpath of the parent directory.
%   dirs (cell array):   List of subdirectories to check.
%   excludeDirs (cell array):  List of fullpaths of directories to exclude.
%
%   Returns:
%      cell array:  list of fullpaths of directories not excluded.
%
%   Note:  if dirs includes sub3/exclude1 and exclude1 and excludeDirs
%   includes exclude1, the sub3/exclude1 will not be filtered.
%   Similarly, exclude1/sub2 will not be filtered. This function 
%   is designed to work only at the immediate subdirectory level.
%
    dirMask = false(length(dirs), 1);
    newDirs = cell(length(dirs), 1);
    for k = 1:length(dirs)
        newDirs{k} = fullfile([parentDir filesep dirs{k}]);
        if ~ismember(newDirs{k}, excludeDirs)
            dirMask(k) = true;
        end
    end
    newDirs = newDirs(dirMask);
end