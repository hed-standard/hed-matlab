basePath = 'g:\HEDMatlab\hed-matlab\data\eeg_ds003645s_hed_demo';
jsonPath = fullfile(basePath, filesep, 'task-FacePerception_events.json');
eventsPath = fullfile(basePath,filesep, 'sub-002', ...
    filesep, 'ses-1', filesep, 'EEG', filesep,...
    'sub-002_ses-1_task-FacePerception_run-1_events.tsv'); 
events = getEvents(fileread(eventsPath), fileread(jsonPath));
hedSchema = getHedSchema('8.2.0');
query = 'Sensory-event';
factorVector = getHEDFactor(query, events, hedSchema, {}, true, true);