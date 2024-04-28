classdef TestGetHedFactor < matlab.unittest.TestCase

    properties
        hedMod
        tabObj
        hedSchema
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
    
            testCase.hedMod = py.importlib.import_module('hed');
            myPath = mfilename("fullpath");  
            [curDir, ~, ~] = fileparts(myPath);
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep, 'eeg_ds003645s_hed_demo');
            jsonPath = fullfile(dataPath, filesep, ...
                'task-FacePerception_events.json'); 
            eventsPath = fullfile(dataPath, filesep, 'sub-002', ...
                filesep, 'ses-1', filesep, 'EEG', filesep,...
                'sub-002_ses-1_task-FacePerception_run-1_events.tsv'); 
            events = fileread(eventsPath);
            sidecar = fileread(jsonPath);
            testCase.tabObj = getTabularInput(events, sidecar);
            testCase.hedSchema = ...
                testCase.hedMod.schema.load_schema_version('8.2.0');
        end
    end

    methods (Test)

        function testNoConditionsContextNoDefs(testCase)
            % Test single version
            remove_types = {'Condition-variable', 'Task'};
            hedObjs1 = getHedStringObjs(testCase.tabObj, ...
               testCase.hedSchema, remove_types, true, true);
            result1a = getHedFactor('Sensory-presentation', hedObjs1);
            testCase.verifyEqual(length(result1a), sum(result1a));
            result1b = getHedFactor('Agent-action', hedObjs1);
            testCase.verifyEqual(sum(result1b), 44)
        end

        function testConditionsContextNoDefs(testCase)
            hedObjs2 = getHedStringObjs(testCase.tabObj, ...
               testCase.hedSchema, {}, true, true);
            result2a = getHedFactor('Sensory-presentation', hedObjs2);
            testCase.verifyEqual(length(result2a), sum(result2a));
            result2b = getHedFactor('Agent-action', hedObjs2);
            testCase.verifyEqual(sum(result2b), 44);
        end

        function testConditionsNoContextNoDefs(testCase)
            hedObjs3 = getHedStringObjs(testCase.tabObj, ...
               testCase.hedSchema, {}, false, true);
            result3a = getHedFactor('Sensory-presentation', hedObjs3);
            testCase.verifyEqual(sum(result3a), 155);
            result3b = getHedFactor('Agent-action', hedObjs3);
            testCase.verifyEqual(sum(result3b), 44);
        end

        function testConditionsNoContextDefs(testCase)
            hedObjs4 = getHedStringObjs(testCase.tabObj, ...
               testCase.hedSchema, {}, false, false);
            result4a = getHedFactor('Sensory-presentation', hedObjs4);
            testCase.verifyEqual(sum(result4a), 0);
            result4b = getHedFactor('Agent-action', hedObjs4);
            testCase.verifyEqual(sum(result4b), 44);
        end

    end
end