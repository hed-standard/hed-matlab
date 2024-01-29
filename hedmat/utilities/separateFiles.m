function [sep_files, sep_dirs] = separateFiles(dirPath)
% Separate the files in a directory into lists of directories and files.
%
% Parameters:
%     dirPath (str)  Full path of a directory whose contents are separated.
%
% Returns:
%     sep_files  Cell array of full paths of the files in dirPath
%     sep_dirs   Cell array of the full paths of the subdirectories in dirPath


    if exist(dirPath, 'dir') ~= 7
       error('separateFiles:dirPathNotADirectory', ...
             'Must provide a path to an actual directory that exists');
    end
    results = dir(dirPath);
    fileTest = false(length(results), 1);
    fileNames = cell(length(results), 1);
    dotTest = false(length(results), 1);
    for k = 1:length(results)
        fileNames{k} = [dirPath filesep results(k).name];
        if ~results(k).isdir
            fileTest(k) = true;
        elseif strcmp(results(k).name, '.') || strcmp(results(k).name, '..')
            dotTest(k) = true;
        end
    end
    sep_files = fileNames(fileTest);
    sep_dirs = fileNames(~fileTest & ~dotTest);
end