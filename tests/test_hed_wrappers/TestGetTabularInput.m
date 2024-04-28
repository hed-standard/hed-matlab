classdef TestGetTabularInput < matlab.unittest.TestCase

    properties
        hedModule
        eventsPath
        jsonPath
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hedModule = py.importlib.import_module('hed');
            myPath = mfilename("fullpath");  
            [curDir, ~, ~] = fileparts(myPath);
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep, 'eeg_ds003645s_hed_demo');
            testCase.jsonPath = fullfile(dataPath, filesep, ...
                'task-FacePerception_events.json'); 
            testCase.eventsPath = fullfile(dataPath, filesep, 'sub-002', ...
                filesep, 'ses-1', filesep, 'EEG', filesep,...
                'sub-002_ses-1_task-FacePerception_run-1_events.tsv'); 
        end
    end

    methods (Test)

        function testSimple(testCase)
            % Test single version
            events = fileread(testCase.eventsPath);
            sidecar = fileread(testCase.jsonPath);
            tabObj = getTabularInput(events, sidecar);
            testCase.assertTrue(py.isinstance(tabObj, ...
                testCase.hedModule.TabularInput));

        end

        function testNoSidecar(testCase)
            % Test single version
            events = fileread(testCase.eventsPath);
            sidecar = py.None;
            tabObj = getTabularInput(events, sidecar);
            testCase.assertTrue(py.isinstance(tabObj, ...
                testCase.hedModule.TabularInput));

        end

    end
end