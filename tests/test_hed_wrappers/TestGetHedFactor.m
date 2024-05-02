classdef TestGetHedFactor < matlab.unittest.TestCase

    properties
        hmod
        tabular_obj
        schema
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
    
            testCase.hmod = py.importlib.import_module('hed');
            [cur_dir, ~, ~] = fileparts(mfilename("fullpath"));
            data_path = fullfile(cur_dir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep, 'eeg_ds003645s_hed_demo');
            json_path = fullfile(data_path, filesep, ...
                'task-FacePerception_events.json'); 
            events_path = fullfile(data_path, filesep, 'sub-002', ...
                filesep, 'ses-1', filesep, 'EEG', filesep,...
                'sub-002_ses-1_task-FacePerception_run-1_events.tsv'); 
            events = fileread(events_path);
            sidecar = fileread(json_path);
            testCase.tabular_obj = get_tabular_obj(events, sidecar);
            testCase.schema = ...
                testCase.hmod.schema.load_schema_version('8.2.0');
        end
    end

    methods (Test)

        function testNoConditionsContextNoDefs(testCase)
            % Test single version
            remove_types = {'Condition-variable', 'Task'};
            hed_string_objs = get_string_objs(testCase.tabular_obj, ...
               testCase.schema, remove_types, true, true);
            result1a = get_hed_factor('Sensory-presentation', hed_string_objs);
            testCase.verifyEqual(length(result1a), sum(result1a));
            result1b = get_hed_factor('Agent-action', hed_string_objs);
            testCase.verifyEqual(sum(result1b), 44)
        end

        function testConditionsContextNoDefs(testCase)
            hed_string_objs = get_string_objs(testCase.tabular_obj, ...
               testCase.schema, {}, true, true);
            resulta = ...
                get_hed_factor('Sensory-presentation', hed_string_objs);
            testCase.verifyEqual(length(resulta), sum(resulta));
            resultb = get_hed_factor('Agent-action', hed_string_objs);
            testCase.verifyEqual(sum(resultb), 44);
        end

        function testConditionsNoContextNoDefs(testCase)
            hed_string_objs = get_string_objs(testCase.tabular_obj, ...
               testCase.schema, {}, false, true);
            resulta = ...
                get_hed_factor('Sensory-presentation', hed_string_objs);
            testCase.verifyEqual(sum(resulta), 155);
            resultb = get_hed_factor('Agent-action', hed_string_objs);
            testCase.verifyEqual(sum(resultb), 44);
        end

        function testConditionsNoContextDefs(testCase)
            hed_string_objs = get_string_objs(testCase.tabular_obj, ...
               testCase.schema, {}, false, false);
            result4a = ...
                get_hed_factor('Sensory-presentation', hed_string_objs);
            testCase.verifyEqual(sum(result4a), 0);
            result4b = get_hed_factor('Agent-action', hed_string_objs);
            testCase.verifyEqual(sum(result4b), 44);
        end

    end
end