classdef TestHedService < matlab.unittest.TestCase

    properties
       hcon
    end

    methods (TestClassSetup)
        function setConnection(testCase)
            testCase.hcon = HedService('http://127.0.0.1:5000');
        end
    end

    methods (Test)

        function testCreateConnection(testCase)
            % Test a simple string
            hcon_dev = HedService('https://hedtools.org/hed_dev');
            testCase.verifyTrue(isa(hcon_dev, 'HedService'));   
        end
            
        function testBasicValidString(testCase)

            issues = testCase.hcon.validate_hedtags('Red, Blue', ...
                 '8.2.0', true, struct());
            testCase.verifyEqual(strlength(issues), 0);

        end

        function testCheckWarningsValidString(testCase)
         
            issues = testCase.hcon.validate_hedtags('Red, Blue/Apple', ...
                '8.2.0', true, struct());
            testCase.verifyGreaterThan(strlength(issues), 0);
            issues = validate_hedtags('Red, Blue/Apple', ...
                '8.2.0', false, struct());
            testCase.verifyEqual(strlength(issues), 0);

            % Test with extension and check for warnings is false
            issues = validate_hedtags('Red, Blue/Apple', ...
                '8.2.0', false, struct());
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid HED string with ext has no errors.');
        end

        function testListMixedStrings(testCase)
            issues = testCase.hcon.validate_hedtags( ...
                {'Red, Blue/Apple', 'Green, Blech'}, ...
                '8.2.0', true, struct());
            testCase.verifyEqual(length(issues), 2);
            testCase.verifyGreaterThan(strlength(issues), 0);
            issues = validate_hedtags(...
                {'Red, Blue/Apple', 'Green, Blech'}, ...
                '8.2.0', false, struct());
            testCase.verifyEqual(length(issues), 1);
        end


        % % Todo: test with and without schema
        % Todo: test with definitions

    end
end