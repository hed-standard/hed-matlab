classdef TestGetStringObjs < matlab.unittest.TestCase

    properties
        hmod
        umod
        tabular_obj
        schema
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hmod = py.importlib.import_module('hed');
            testCase.umod = py.importlib.import_module(...
                'hed.tools.analysis.annotation_util');
            myPath = mfilename("fullpath");
            [curDir, ~, ~] = fileparts(myPath);
            data_path = fullfile(curDir, filesep, '..', filesep, '..', ...
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

        function testNoTypesContextDef(testCase)
            % Test single version
            remove_types = {'Condition-variable', 'Task'};
            string_objs = get_string_objs(testCase.tabular_obj, ...
                testCase.schema, remove_types, true, true);
            string_cells = cell(string_objs);
            testCase.verifyTrue(py.isinstance(string_cells{1}, ...
                testCase.hmod.HedString))
            hed_strings = ...
                string(cell(testCase.umod.to_strlist(string_objs)));
            testCase.verifyTrue(ischar(hed_strings{1}))
            testCase.verifyEqual(length(hed_strings{1}), 382);
        end

        function testTypesContextDefs(testCase)
            string_objs = get_string_objs(testCase.tabular_obj, ...
                testCase.schema, {}, true, true);
            string_cells = cell(string_objs);
            testCase.verifyTrue(py.isinstance(string_cells{2}, ...
                testCase.hmod.HedString))
            hedStrs2 = ...
                string(cell(testCase.umod.to_strlist(string_objs)));
            testCase.verifyEqual(length(hedStrs2{1}), 678);
        end

        function testTypesNoContextDefs(testCase)
            string_objs = get_string_objs(testCase.tabular_obj, ...
                testCase.schema, {}, false, true);
            string_cells = cell(string_objs);
            testCase.verifyTrue(py.isinstance(string_cells{2}, ...
                testCase.hmod.HedString))
            hed_strings = ...
                string(cell(testCase.umod.to_strlist(string_objs)));
            testCase.verifyEqual(length(hed_strings{1}), 678);
        end

        function testTypesNoContextNoDefs(testCase)
            string_objs = get_string_objs(testCase.tabular_obj, ...
                testCase.schema, {}, false, false);
            string_cells = cell(string_objs);
            testCase.verifyTrue(py.isinstance(string_cells{2}, ...
                testCase.hmod.HedString))
            hed_strings = ...
                string(cell(testCase.umod.to_strlist(string_objs)));
            testCase.verifyEqual(length(hed_strings{1}), 123);
        end

    end
end