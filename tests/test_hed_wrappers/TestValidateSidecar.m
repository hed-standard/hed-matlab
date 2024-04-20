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
            % Test with schema object passed
            issues = validateSidecar(testCase.goodSidecar, ...
                testCase.hedSchema, true);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid sidecar should not have issues.');
            
            % Test with schema version passed
            issues = validateSidecar(testCase.goodSidecar, '8.2.0', true);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid sidecar should not have issues.');
        end

        function testValidFromPath(testCase)
            % Test with schema object passed
            issues = validateSidecar(testCase.goodPath, ...
                testCase.hedSchema, true);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid sidecar should not have issues.');
            
            % Test with schema version passed
            issues = validateSidecar(testCase.goodPath, '8.2.0', true);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid sidecar should not have issues.');
        end

        function testInvalidSidecar(testCase)
            % Test with schema object passed
            issues = validateSidecar(testCase.badPath, ...
                testCase.hedSchema, true);
            testCase.verifyGreaterThan(strlength(issues), 0, ...
                'Invalid sidecar should have issues.');
            
            % Test with schema version passed
            issues = validateSidecar(testCase.badPath, '8.2.0', true);
            testCase.verifyGreaterThan(strlength(issues), 0, ...
                'Invalid sidecar should have issues.');
        end

    end
end