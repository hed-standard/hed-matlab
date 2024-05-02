classdef TestEvents2String < matlab.unittest.TestCase

    properties
        umod
        hmod
        json_path
        events_path
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hmod = py.importlib.import_module('hed');
            testCase.umod =  py.importlib.import_module( ...
                'hed.tools.analysis.annotation_util');
            myPath = mfilename("fullpath");  
            [curDir, ~, ~] = fileparts(myPath);
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                                filesep, 'data');
            testCase.json_path = fullfile(dataPath, filesep, ...
                 filesep, 'eeg_ds003645s_hed_demo', filesep, ...
                 'task-FacePerception_events.json'); 
            testCase.events_path = fullfile(dataPath, filesep, ...
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
            event_string = events2string(events);
            testCase.verifyTrue(isstring(event_string))
            tabIn = testCase.umod.str_to_tabular(event_string);
            testCase.verifyTrue(py.isinstance(tabIn, ...
                testCase.hmod.TabularInput));
        end

        function testRealData(testCase)
            x = load(testCase.events_path);
            events = x.events;
            testCase.verifyTrue(isstruct(events));
            testCase.verifyTrue(~ismember('onset', fieldnames(events)));
            testCase.verifyTrue(~ismember('duration', fieldnames(events)));
            events_rectified = rectify_events(events, 1100);
            testCase.verifyTrue(ismember('onset', ...
                fieldnames(events_rectified)));
            testCase.verifyTrue(ismember('duration', ...
                fieldnames(events_rectified)));
            event_string = events2string(events_rectified);
            testCase.verifyTrue(isstring(event_string));
            tab_in = testCase.umod.str_to_tabular(event_string);
            testCase.verifyTrue(py.isinstance(tab_in, ...
                testCase.hmod.TabularInput));
        end
    end
end