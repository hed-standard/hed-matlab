%% load up the stuff
rootPath = 'G:/ds002718-download';
sidecarPath = fullfile(rootPath, filesep, 'task-FaceRecognition_events.json');
sidecarString = fileread(sidecarPath);
EEG_name = 'sub-002_task-FaceRecognition_eeg.set';
EEG1_path = fullfile(rootPath, filesep, 'derivatives', filesep, ...
    'eeglab', filesep, 'sub-002', filesep, 'eeg');
EEG_path = fullfile(rootPath, filesep, 'sub-002', filesep, 'eeg');
EEG1 = pop_loadset('filename', EEG_name, 'filepath', EEG1_path);
EEG = pop_loadset('filename', EEG_name, 'filepath', EEG_path);

%% Convert the events to a cell:
events = EEG.event;
eventsCell = struct2cell(events);
eventsTable = struct2table(events);
eventsCellTable = table2cell(eventsTable);