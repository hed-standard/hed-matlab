classdef TestHedToolsService < matlab.unittest.TestCase

    properties
       hcon
    end

    methods (TestClassSetup)
        function setConnection(testCase)
            testCase.hcon = getHedTools('http://127.0.0.1:5000');
            testCase.hcon.setHedVersion('8.2.0')
        end
    end

    methods (Test)

        function testCreateConnection(testCase)
            % Test a simple string
            hed = getHedTools('https://hedtools.org/hed_dev');
            testCase.verifyTrue(isa(hed, 'HedToolsService'));   
        end
            
        function testBasicValidString(testCase)
            % Test simple validation
            issues = testCase.hcon.validate_hedtags('Red, Blue', true);
            testCase.verifyEqual(strlength(issues), 0);
        end

        function testCheckWarningsValidString(testCase)
         
            issues = testCase.hcon.validate_hedtags('Red, Blue/Apple', ...
                true);
            testCase.verifyGreaterThan(strlength(issues), 0);
            issues = validate_hedtags('Red, Blue/Apple', false);
            testCase.verifyEqual(strlength(issues), 0);

            % Test with extension and check for warnings is false
            issues = validate_hedtags('Red, Blue/Apple', false);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid HED string with ext has no errors.');
        end

        function testListMixedStrings(testCase)
            issues = testCase.hcon.validate_hedtags( ...
                {'Red, Blue/Apple', 'Green, Blech'}, true);
            testCase.verifyEqual(length(issues), 2);
            testCase.verifyGreaterThan(strlength(issues), 0);
            issues = validate_hedtags(...
                {'Red, Blue/Apple', 'Green, Blech'}, false);
            testCase.verifyEqual(length(issues), 1);
        end


        % % Todo: test with and without schema
        % Todo: test with definitions

    end
end