classdef TestEvents2Struct < matlab.unittest.TestCase

    properties
        UtilMod
        HedMod
        jsonPath
        eventsPath
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.HedMod = py.importlib.import_module('hed');
            testCase.UtilMod =  py.importlib.import_module( ...
                'hed.tools.analysis.annotation_util');
            myPath = mfilename("fullpath");  
            [curDir, ~, ~] = fileparts(myPath);
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                                filesep, 'data');
            testCase.jsonPath = fullfile(dataPath, filesep, ...
                 filesep, 'eeg_ds003645s_hed_demo', filesep, ...
                 'task-FacePerception_events.json'); 
            testCase.eventsPath = fullfile(dataPath, filesep, ...
                'other_data', filesep, 'EEGevents.mat');
        end
    end

    methods (Test)

        function testWithOnsetAndDuration(testCase)
            events(3) = struct('onset', 3.2, 'duration', NaN, ...
                'latency', 6234, 'response', 2.1, 'type', 'apple');
            events(2) = struct('onset', 2.2, 'duration', NaN, ...
                 'latency', 5234, 'response', NaN, 'type', 'pear');
            events(1) = struct('onset', 1.1, 'duration', NaN,  'latency', 4234, ...
                 'response', 1.5, 'type', 'banana');
            eventString = events2String(events);
            testCase.verifyTrue(isstring(eventString))
            tabIn = testCase.UtilMod.str_to_tabular(eventString);
            testCase.verifyTrue(py.isinstance(tabIn, ...
                testCase.HedMod.TabularInput));
        end

        function testRealData(testCase)
            x = load(testCase.eventsPath);
            events = x.events;
            testCase.verifyTrue(isstruct(events));
            testCase.verifyTrue(~ismember('onset', fieldnames(events)));
            eventsNew = rectifyEvents(events, 1100);
            testCase.verifyTrue(ismember('onset', fieldnames(eventsNew)));
            disp(fieldnames(eventsNew))
        end
    end
end