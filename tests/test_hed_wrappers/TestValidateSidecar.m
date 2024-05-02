classdef TestValidateSidecar < matlab.unittest.TestCase

    properties
        hmod
        umod
        schema
        good_sidecar
        bad_sidecar
        good_path
        bad_path
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hmod = py.importlib.import_module('hed');
            testCase.umod = py.importlib.import_module(...
                'hed.tools.analysis.annotation_util');
            testCase.schema = get_schema_obj('8.2.0');  
            [cur_dir, ~, ~] = fileparts(mfilename("fullpath"));
            data_path = fullfile(cur_dir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep);
            testCase.good_path = fullfile(data_path, 'eeg_ds003645s_hed_demo', ...
                filesep, 'task-FacePerception_events.json');
            testCase.bad_path = fullfile(data_path, filesep, 'other_data', ...
                'both_types_events_errors.json');
            testCase.good_sidecar = ...
                testCase.hmod.Sidecar(testCase.good_path);
            testCase.bad_sidecar = ...
                testCase.hmod.Sidecar(testCase.bad_path);
        end
    end

    methods (Test)

        function testValidSidecar(testCase)
            % Test on Sidecar obj with schema object passed
            issue_string = validate_sidecar(testCase.good_sidecar, ...
                testCase.schema, true);
            testCase.verifyEqual(strlength(issue_string), 0, ...
                'Valid sidecar should not have issues.');
            
            % Test on Sidecar obj with schema version passed
            issue_string = validate_sidecar(testCase.good_sidecar, ...
                '8.2.0', true);
            testCase.verifyEqual(strlength(issue_string), 0, ...
                'Valid sidecar should not have issues.');
        end

        function testValidFromString(testCase)
            % Test Json path with schema object passed
            json_str = fileread(testCase.good_path);
            sidecar = testCase.umod.strs_to_sidecar(json_str);
            issue_string = validate_sidecar(sidecar, testCase.schema, true);
            testCase.verifyEqual(strlength(issue_string), 0, ...
                'Valid sidecar should not have issues.');
            
            % Test with schema version passed
            issue_string = validate_sidecar(sidecar, '8.2.0', true);
            testCase.verifyEqual(strlength(issue_string), 0, ...
                'Valid sidecar should not have issues.');
        end

        function testInvalidSidecar(testCase)
            % Test with schema object passed
            issue_string = validate_sidecar(testCase.bad_sidecar, ...
                testCase.schema, true);
            testCase.verifyGreaterThan(strlength(issue_string), 0, ...
                'Invalid sidecar should have issues.');
            
            % Test with schema version passed
            issue_string = validate_sidecar(testCase.bad_sidecar, ...
                '8.2.0', true);
            testCase.verifyGreaterThan(strlength(issue_string), 0, ...
                'Invalid sidecar should have issues.');
        end

        function testMultipleOutput(testCase)
            % Test with schema object passed
            [issue_string, has_errors] = validate_sidecar( ...
                testCase.bad_sidecar, testCase.schema, true);
            testCase.verifyTrue(has_errors);
            testCase.verifyTrue(isstring(issue_string));
        end

    end
end