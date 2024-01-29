%% Create a list with all of the files of a type in a directory tree
function selectedFiles = getFileList(rootPath, namePrefix, nameSuffix, ...
    extensions, excludeDirs)
%% Return a full path list of specified files in rootPath directory tree.
%
%  Parameters:
%      rootPath    (char) full path of root of directory tree to search
%      namePrefix  (char) prefix of the filename or any if empty string
%      nameSuffix  (char) suffix of the filename or any if empty string
%      extensions  (cell array) names of extensions (with . included)
%      excludeDirs (cell array) names of subdirectories to exclude
%
%  Returns: 
%      selectedList    (cell array) list of full paths of the files 
% 

    selectedFiles = {};
    if isempty(rootPath)
        throw(MException('getFileList:RootDirIsEmpty', ...
                         'Must provide a path to a directory'));
    end
    excludePaths = {};
    if ~isempty(excludeDirs)
        stringPrefix = [rootPath filesep];
        excludePaths = cellfun(@(x) [stringPrefix, x], excludeDirs, ...
            'UniformOutput', false);
    end
    dirList = {};
    nextDir = rootPath;
    while ~isempty(nextDir)
        [sep_files, sep_dirs] = separateFiles(nextDir);
        filteredDirs = filterDirectories(sep_dirs, excludePaths);
        filteredFiles = filterFiles(sep_files, namePrefix, ...
            nameSuffix, extensions);
        if ~isempty(filteredFiles)
            selectedFiles = [selectedFiles; filteredFiles(:)]; %#ok<AGROW>
        end
        if ~isempty(filteredDirs)
            dirList = [dirList; filteredDirs(:)]; %#ok<AGROW>
        end
        if ~isempty(dirList)
            nextDir = dirList{1};
            dirList = dirList(2:end);
        else
            break;
        end
    end
end

