rootPath = 'G:/HEDMatlab/hed-matlab/data/eeg_ds003645s_hed_demo';

% xx = getFileList(rootPath, 'test', '', {'.m'}, {});
% 
% y = x';

% [x1, y1] = separateFiles(rootPath)

try
    filterFiles(1, 2, 3, 4, 5);
catch ME
    disp(ME)
end
