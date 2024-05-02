classdef TestGetTabularObj < matlab.unittest.TestCase

    properties
        hmod
        events_path
        json_path
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hmod = py.importlib.import_module('hed');
            my_path = mfilename("fullpath");  
            [curDir, ~, ~] = fileparts(my_path);
            data_path = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep, 'eeg_ds003645s_hed_demo');
            testCase.json_path = fullfile(data_path, filesep, ...
                'task-FacePerception_events.json'); 
            testCase.events_path = fullfile(data_path, filesep, 'sub-002', ...
                filesep, 'ses-1', filesep, 'EEG', filesep,...
                'sub-002_ses-1_task-FacePerception_run-1_events.tsv'); 
        end
    end

    methods (Test)

        function testSimple(testCase)
            % Test single version
            events = fileread(testCase.events_path);
            sidecar = fileread(testCase.json_path);
            tabular_obj = get_tabular_obj(events, sidecar);
            testCase.assertTrue(py.isinstance(tabular_obj, ...
                testCase.hmod.TabularInput));
        end

        function testNoSidecar(testCase)
            % Test single version
            events = fileread(testCase.events_path);
            sidecar = py.None;
            tabular_obj = get_tabular_obj(events, sidecar);
            testCase.assertTrue(py.isinstance(tabular_obj, ...
                testCase.hmod.TabularInput));
        end
    end
end