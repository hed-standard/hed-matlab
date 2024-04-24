classdef TestValidateSidecar < matlab.unittest.TestCase

    properties
        hedModule
        hedSchema
        goodSidecar
        badSidecar
        goodPath
        badPath
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hedModule = py.importlib.import_module('hed');
            testCase.hedSchema = getHedSchema('8.2.0');
                myPath = mfilename("fullpath");  
            [curDir, ~, ~] = fileparts(myPath);
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep);
            testCase.goodPath = fullfile(dataPath, 'eeg_ds003645s_hed_demo', ...
                filesep, 'task-FacePerception_events.json');
            testCase.badPath = fullfile(dataPath, filesep, 'other_data', ...
                'both_types_events_errors.json');
            testCase.goodSidecar = ...
                testCase.hedModule.Sidecar(testCase.goodPath);
            testCase.badSidecar = ...
                testCase.hedModule.Sidecar(testCase.badPath);
        end
    end

    methods (Test)

        function testValidSidecar(testCase)
            % Test on Sidecar obj with schema object passed
            issueString = validateSidecar(testCase.goodSidecar, ...
                testCase.hedSchema, true);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid sidecar should not have issues.');
            
            % Test on Sidecar obj with schema version passed
            issueString = validateSidecar(testCase.goodSidecar, '8.2.0', true);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid sidecar should not have issues.');
        end

        function testValidFromString(testCase)
            % Test Json path with schema object passed
            json_str = fileread(testCase.goodPath);
            sidecar = testCase.hedModule.tools.analysis.annotation_util.strs_to_sidecar(json_str);
            issueString = validateSidecar(sidecar, testCase.hedSchema, true);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid sidecar should not have issues.');
            
            % Test with schema version passed
            issueString = validateSidecar(sidecar, '8.2.0', true);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid sidecar should not have issues.');
        end

        function testInvalidSidecar(testCase)
            % Test with schema object passed
            issueString = validateSidecar(testCase.badSidecar, ...
                testCase.hedSchema, true);
            testCase.verifyGreaterThan(strlength(issueString), 0, ...
                'Invalid sidecar should have issues.');
            
            % Test with schema version passed
            issueString = validateSidecar(testCase.badSidecar, '8.2.0', true);
            testCase.verifyGreaterThan(strlength(issueString), 0, ...
                'Invalid sidecar should have issues.');
        end

        function testMultipleOutput(testCase)
            % Test with schema object passed
            [issueString, hasErrors] = validateSidecar(testCase.badSidecar, ...
                testCase.hedSchema, true);
            testCase.verifyTrue(hasErrors);
            testCase.verifyTrue(isstring(issueString));
        end

    end
end