classdef TestValidateEvents < matlab.unittest.TestCase

    properties
        hedModule
        hedSchema
        goodSidecar
        badSidecar
        eventString
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hedModule = py.importlib.import_module('hed');
            testCase.hedSchema = getHedSchema('8.2.0');
                myPath = mfilename("fullpath");  
            [curDir, ~, ~] = fileparts(myPath);
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep);
            goodPath = fullfile(dataPath, 'eeg_ds003645s_hed_demo', ...
                filesep, 'task-FacePerception_events.json');
            badPath = fullfile(dataPath, filesep, 'other_data', ...
                'both_types_events_errors.json');
            testCase.goodSidecar = ...
                testCase.hedModule.Sidecar(goodPath);
            testCase.badSidecar = ...
                testCase.hedModule.Sidecar(badPath);
            dataPath = fullfile(dataPath, ...
                filesep, 'eeg_ds003645s_hed_demo');   
            eventsPath = fullfile(dataPath, filesep, 'sub-002', ...
                filesep, 'ses-1', filesep, 'EEG', filesep,...
                'sub-002_ses-1_task-FacePerception_run-1_events.tsv'); 
            testCase.eventString = fileread(eventsPath);

        end
    end

    methods (Test)

        function testValidEvents(testCase)
            % Test on valid Sidecar
            events = getTabularInput(testCase.eventString, testCase.goodSidecar);
            [issues, hasErrors] = validateEvents(events, ...
                testCase.hedSchema, true);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid events with good sidecar should not have issues.');
            testCase.verifyFalse(hasErrors);
        end

        function testInvalidEvents(testCase)
            events = getTabularInput(testCase.eventString, testCase.badSidecar);
            [issueString, hasErrors] = validateEvents(events, ...
                testCase.hedSchema, true);
            testCase.verifyTrue(isstring(issueString));
            testCase.verifyTrue(hasErrors);
        end

        function testNoSidecar(testCase)
            % Test with schema object passed
            events = getTabularInput(testCase.eventString, py.None);
            [issues, hasErrors] = validateEvents(events, ...
                testCase.hedSchema, false);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid events with no sidecar should not have issues.');
            testCase.verifyFalse(hasErrors);
            [issues1, hasErrors1] = validateEvents(events, ...
                testCase.hedSchema, true);
            testCase.verifyGreaterThan(strlength(issues1), 0, ...
                'Valid events with no sidecar should has warning.');
            testCase.verifyFalse(hasErrors1);
        end

    end
end