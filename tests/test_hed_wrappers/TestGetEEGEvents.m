classdef TestGetEEGEvents < matlab.unittest.TestCase

    properties
        
    end

    methods (TestClassSetup)
   
    end

    methods (Test)

        function testEventsWithOnset(testCase)
            % Test events with onset
            events1(3) = struct('onset', 3.2, 'latency', 6234, ...
                             'response', 2.1, 'type', 'apple');
            events1(2) = struct('onset', 2.2, 'latency', 5234, ...
                             'response', NaN, 'type', 'pear');
            events1(1) = struct('onset', 1.1, 'latency', 4234, ...
                             'response', 1.5, 'type', 'banana');
            table1 = getEEGEvents(events1, '500');
            testCase.assertTrue(istable(table1), ...
                'getEEGEvents should return a table')
            testCase.assertTrue(table1{2, 'response'} == "n/a");
        end

        function testEventsnoOnset(testCase)
            % Test events with onset
            events1(3) = struct('latency', 6234, ...
                             'response', 2.1, 'type', 'apple');
            events1(2) = struct('latency', 5234, ...
                             'response', NaN, 'type', 'pear');
            events1(1) = struct('latency', 4234, ...
                             'response', 1.5, 'type', 'banana');
            table1 = getEEGEvents(events1, 500);
            
            testCase.assertTrue(istable(table1), ...
                'getEEGEvents should return a table')
            testCase.assertTrue(table1{2, 'response'} == "n/a");

            table2 = getEEGEvents(events1, '500');
            testCase.assertTrue(istable(table2), ...
                'getEEGEvents should return a table')
            testCase.assertTrue(table2{2, 'response'} == "n/a");

            table3 = getEEGEvents(events1, 500);
            testCase.assertTrue(istable(table3), ...
                'getEEGEvents should return a table')
            testCase.assertTrue(table3{2, 'response'} == "n/a");
        end

        function testEventsnoOnsetMixed(testCase)
            % Test events with onset
            events1(3) = struct('latency', 6234, ...
                             'response', 2.1, 'type', 'apple');
            events1(2) = struct('latency', '5234', ...
                             'response', NaN, 'type', 'pear');
            events1(1) = struct('latency', "4234", ...
                             'response', 1.5, 'type', 'banana');
            table1 = getEEGEvents(events1, '500');
            
            testCase.assertTrue(istable(table1), ...
                'getEEGEvents should return a table')
            testCase.assertTrue(table1{2, 'response'} == "n/a");
        end

        function testEventsnoNaN(testCase)
            % Test events with onset
            events1(3) = struct('latency', 6234, ...
                             'response', 2.1, 'type', 'apple');
            events1(2) = struct('latency', NaN, ...
                             'response', NaN, 'type', 'pear');
            events1(1) = struct('latency', 5234, ...
                             'response', 1.5, 'type', 'banana');
            table1 = getEEGEvents(events1, '500');
            
            testCase.assertTrue(istable(table1), ...
                'getEEGEvents should return a table')
            testCase.assertTrue(table1{2, 'response'} == "n/a");
        end


    end
end