classdef TestValidateEvents < matlab.unittest.TestCase

    properties
        hmod
        schema
        good_sidecar
        bad_sidecar
        event_string
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hmod = py.importlib.import_module('hed');
            testCase.schema = get_schema_obj('8.2.0'); 
            [cur_dir, ~, ~] = fileparts(mfilename("fullpath"));
            data_path = fullfile(cur_dir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep);
            gpath = fullfile(data_path, 'eeg_ds003645s_hed_demo', ...
                filesep, 'task-FacePerception_events.json');
            bpath = fullfile(data_path, filesep, 'other_data', ...
                'both_types_events_errors.json');
            testCase.good_sidecar = testCase.hmod.Sidecar(gpath);
            testCase.bad_sidecar = testCase.hmod.Sidecar(bpath); 
            epath = fullfile(data_path, ...
                filesep, 'eeg_ds003645s_hed_demo', filesep, 'sub-002', ...
                filesep, 'ses-1', filesep, 'EEG', filesep,...
                'sub-002_ses-1_task-FacePerception_run-1_events.tsv'); 
            testCase.event_string = fileread(epath);

        end
    end

    methods (Test)

        function testValidEvents(testCase)
            % Test on valid Sidecar
            events = get_tabular_obj(testCase.event_string, ...
                testCase.good_sidecar);
            [issues, has_errors] = validate_events(events, ...
                testCase.schema, true);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid events with good sidecar should not have issues.');
            testCase.verifyFalse(has_errors);
        end

        function testInvalidEvents(testCase)
            events = get_tabular_obj(testCase.event_string,...
                testCase.bad_sidecar);
            [issue_string, has_errors] = validate_events(events, ...
                testCase.schema, true);
            testCase.verifyTrue(isstring(issue_string));
            testCase.verifyTrue(has_errors);
        end

        function testNoSidecarNoWarnings(testCase)
            % Test with schema object passed
            events = get_tabular_obj(testCase.event_string, py.None);
            [issues, has_errors] = validate_events(events, ...
                testCase.schema, false);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid events with no sidecar should not have issues.');
            testCase.verifyFalse(has_errors);

        end

        function testNoSidecarWarnings(testCase)
            events = get_tabular_obj(testCase.event_string, py.None);
            [issues, has_errors] = validate_events(events, ...
                testCase.schema, true);
            testCase.verifyGreaterThan(strlength(issues), 0, ...
                'Valid events with no sidecar should has warning.');
            testCase.verifyFalse(has_errors);
        end

    end
end