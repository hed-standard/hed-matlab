function filteredList = filterFiles(fileList, namePrefix, ...
                                    nameSuffix, extensions)
%% Return a list whose filenames satisfy the specified criteria
%
%  Parameters:
%      fileList    (cell array) paths of the files to be filtered.
%      namePrefix  (char) prefix of the filename or any if empty string
%      nameSuffix  (char) suffix of the filename or any if empty string
%      extensions  (cell array) names of extensions (with . included)
%
%  Returns: 
%      filteredList (cell array) paths of files satisfying criteria.
% 

% Returns true if this file entry corresponds to an excluded directory
    lowerExtensions = cellfun(@lower, extensions, 'UniformOutput', false);
    filters = true(length(fileList), 1);
    for k = 1:length(fileList)
        [~, base, ext] = fileparts(fileList{k});
        if ~endsWith(base, nameSuffix) || ~startsWith(base, namePrefix) 
            filters(k) = false;
        elseif ~isempty(lowerExtensions) && ~ismember(lower(ext), lowerExtensions)
            filters(k) = false;
        end
    end
    filteredList = fileList(filters);
end
