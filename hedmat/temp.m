rootPath = 'G:/HEDMatlab/hed-matlab/data/eeg_ds003645s_hed_demo';

% xx = getFileList(rootPath, 'test', '', {'.m'}, {});
% 
% y = x';

% [x1, y1] = separateFiles(rootPath)

try
    filterDirectories('')
catch ME
    disp(ME)
end
