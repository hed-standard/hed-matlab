classdef TestRectifyEvents < matlab.unittest.TestCase

    properties
        
    end

    methods (TestClassSetup)
   
    end

    methods (Test)

        function testWithOnsetAndDuration(testCase)
            events(3) = struct('onset', 3.2, 'duration', NaN, ...
                'latency', 6234, 'response', 2.1, 'type', 'apple');
            events(2) = struct('onset', 2.2, 'duration', NaN, ...
                 'latency', 5234, 'response', NaN, 'type', 'pear');
            events(1) = struct('onset', 1.1, 'duration', NaN,  'latency', 4234, ...
                 'response', 1.5, 'type', 'banana');
            fields = fieldnames(events);
            eventsNew = rectifyEvents(events, 100.0);
            fieldsNew = fieldnames(eventsNew);
            testCase.verifyEqual(length(fields), length(fieldsNew));
            testCase.verifyEmpty(setdiff(fields, fieldsNew));
            testCase.verifyEqual(eventsNew(3).response, 2.1)
        end

        function testNoOnset(testCase)
            % Test events with onset
            events(3) = struct('latency', 6234, ...
                              'response', 2.1, 'type', 'apple', ...
                              'duration', 1.0);
            events(2) = struct('latency', 5234, ...
                              'response', NaN, 'type', 'pear', ...
                              'duration', 1.0);
            events(1) = struct('latency', 4234, ...
                              'response', 1.5, 'type', 'banana', ...
                              'duration', NaN);
            fields = fieldnames(events);
            eventsNew = rectifyEvents(events, 100.0);
            fieldsNew = fieldnames(eventsNew);
            testCase.verifyEqual(length(fields) + 1, length(fieldsNew));
            testCase.verifyEqual(setdiff(fieldsNew, fields), {'onset'});
            testCase.verifyEqual(eventsNew(3).response, 2.1);
            testCase.verifyEqual(fieldsNew{1}, 'onset');
            testCase.verifyTrue(isnan(eventsNew(1).duration));
        end

        function testNoOnsetNoDuration(testCase)
            % Test events with no onset or duration
            events(3) = struct('latency', 6234, ...
                             'response', 2.1, 'type', 'apple');
            events(2) = struct('latency', '5234', ...
                             'response', NaN, 'type', 'pear');
            events(1) = struct('latency', "4234", ...
                             'response', 1.5, 'type', 'banana');
            fields = fieldnames(events);
            eventsNew = rectifyEvents(events, 100.0);
            fieldsNew = fieldnames(eventsNew);
            testCase.verifyEqual(length(fields) + 2, length(fieldsNew));
            testCase.verifyEqual(setdiff(fieldsNew', fields'), {'duration', 'onset'});
            testCase.verifyEqual(eventsNew(3).response, 2.1);
            testCase.verifyEqual(fieldsNew{1}, 'onset');
            testCase.verifyTrue(isnan(eventsNew(1).duration));
        end

    end
end