classdef TestGetHedStringObjs < matlab.unittest.TestCase

    properties
        hedMod
        eventsObj
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
            testCase.eventsObj = getTabularInput(events, sidecar);
            testCase.hedSchema = ...
                testCase.hedMod.schema.load_schema_version('8.2.0');
        end
    end

    methods (Test)

        function testSimple(testCase)
            % Test single version
            utilMod = py.importlib.import_module( ...
                'hed.tools.analysis.annotation_util');
            remove_types = {'Condition-variable', 'Task'};
            hedObjs1 = getHedStringObjs(testCase.eventsObj, ...
               testCase.hedSchema, remove_types, true, true);
            hedObjs1Cell = cell(hedObjs1);
            testCase.verifyTrue(py.isinstance(hedObjs1Cell{1}, ...
                testCase.hedMod.HedString))
            hedStrs1 = string(cell(utilMod.to_strlist(hedObjs1)));
            testCase.verifyTrue(ischar(hedStrs1{1}))
            hedObjs2 = getHedStringObjs(testCase.eventsObj, ...
               testCase.hedSchema, {}, true, true);
            hedObjs2Cell = cell(hedObjs2);
            testCase.verifyTrue(py.isinstance(hedObjs2Cell{2}, ...
                testCase.hedMod.HedString))
            hedStrs2 = string(cell(utilMod.to_strlist(hedObjs2)));
            hedObjs3 = getHedStringObjs(testCase.eventsObj, ...
               testCase.hedSchema, {}, false, true);
            hedObjs3Cell = cell(hedObjs3);
            testCase.verifyTrue(py.isinstance(hedObjs3Cell{2}, ...
                testCase.hedMod.HedString))
            hedStrs3 = string(cell(utilMod.to_strlist(hedObjs3)));
            hedObjs4 = getHedStringObjs(testCase.eventsObj, ...
               testCase.hedSchema, {}, false, false);
            hedObjs4Cell = cell(hedObjs4);
            testCase.verifyTrue(py.isinstance(hedObjs4Cell{2}, ...
                testCase.hedMod.HedString))
            hedStrs4 = string(cell(utilMod.to_strlist(hedObjs4)));
            testCase.verifyEqual(length(hedStrs1{1}), 382);
            testCase.verifyEqual(length(hedStrs2{1}), 678);
            testCase.verifyEqual(length(hedStrs3{1}), 678);
            testCase.verifyEqual(length(hedStrs4{1}), 123);
        end

    end
end