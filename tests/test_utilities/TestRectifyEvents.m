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
            events_rectified = rectify_events(events, 100.0);
            fields_new = fieldnames(events_rectified);
            testCase.verifyEqual(length(fields), length(fields_new));
            testCase.verifyEmpty(setdiff(fields, fields_new));
            testCase.verifyEqual(events_rectified(3).response, 2.1)
            events_rectified = rectify_events(events);
            fields_new = fieldnames(events_rectified);
            testCase.verifyEqual(length(fields), length(fields_new));
            testCase.verifyEmpty(setdiff(fields, fields_new));
            testCase.verifyEqual(events_rectified(3).response, 2.1)
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
            events_rectified = rectify_events(events, 100.0);
            fields_new = fieldnames(events_rectified);
            testCase.verifyEqual(length(fields) + 1, length(fields_new));
            testCase.verifyEqual(setdiff(fields_new, fields), {'onset'});
            testCase.verifyEqual(events_rectified(3).response, 2.1);
            testCase.verifyEqual(fields_new{1}, 'onset');
            testCase.verifyTrue(isnan(events_rectified(1).duration));
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
            events_rectified = rectify_events(events, 100.0);
            fields_new = fieldnames(events_rectified);
            testCase.verifyEqual(length(fields) + 2, length(fields_new));
            testCase.verifyEqual(...
                setdiff(fields_new', fields'), {'duration', 'onset'});
            testCase.verifyEqual(events_rectified(3).response, 2.1);
            testCase.verifyEqual(fields_new{1}, 'onset');
            testCase.verifyTrue(isnan(events_rectified(1).duration));
        end

        function testBadInputs(testCase)
            % Test for errors with bad inputs
            testCase.verifyError(@() rectify_events(struct()), ...
                'rectify_events:NeedSamplingRate');
            testCase.verifyError(@() rectify_events(struct(), 100), ...
                'rectify_events:MissingLatency');
            testCase.verifyError(@() rectify_events([]), ...
                'rectify_events:InvalidEventStruct');
        end

    end
end