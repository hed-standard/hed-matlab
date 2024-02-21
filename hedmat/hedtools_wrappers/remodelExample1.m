data_path = 'T:/summaryTests/ds003645-download';
remodel_file = 'G:/summarize_tags_rmdl.json';
work_dir = 'G:/tempNew1';
remodel_args = {data_path, remodel_file, '-nb', '-nu', '-x', 'stimuli', ...
    'derivatives', 'code', '.datalad', 'sourcedata', '-w', work_dir, ...
    '-b', '-i', 'none', '-t', 'FacePerception', '-v'};
runRemodel(remodel_args);
