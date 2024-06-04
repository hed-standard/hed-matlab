%% A test script for a wrapper functions for HED remodeling tools

%% Set up the directories
[cur_dir, ~, ~] = fileparts(mfilename("fullpath"));
data_dir = fullfile(cur_dir, filesep, '..', filesep, '..', filesep, 'data');
data_root = fullfile(data_dir, filesep, 'eeg_ds003645s_hed_demo');

%% Backup the data using default backup name (only should be done once)
% This uses all the defaults to back up the events.tsv files.
% The backup named name is default_back is created in the subdirectory 
% derivatives/remodel/backups under bids_root.
backup_args = {data_root, '-x', 'stimuli', 'derivatives'};
remodel_backup(backup_args);

%% Run the remodeling file on a BIDS dataset 
% The -b indicates that this is a BIDS dataset and files are located
% by structure. The '-x' is followed by the directories to be excluded.
remodel_file = fullfile(data_dir, filesep, 'other_data', filesep, ...
    'summarize_hed_types_rmdl.json');
remodel_args = {data_root, remodel_file, '-b', '-x', 'stimuli', 'derivatives'};
remodel(remodel_args);

%% Restore the data files to originals (usually does not have to be done)
% This script uses the default backup
restore_args = {data_root};
remodel_restore(restore_args);

%% An example with more complex command line arguments
% No backup is used in this case and the summaries are stored in
% a temporary directory (-w option).  The data is assumed to be
% in BIDS format (-b option).
remodel_file = fullfile(data_dir, filesep, 'other_data', filesep, ...
    'summarize_hed_tags_rmdl.json');
work_dir = tempdir;
remodel_args = {data_root, remodel_file, '-nb', '-nu', '-x', 'stimuli', ...
    'derivatives', 'code', '.datalad', 'sourcedata', '-w', work_dir, ...
    '-b', '-i', 'none', '-t', 'FacePerception', '-v'};
remodel(remodel_args);
