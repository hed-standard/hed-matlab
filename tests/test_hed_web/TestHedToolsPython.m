classdef TestHedToolsPython < matlab.unittest.TestCase

    properties
       hed
    end

    methods (TestClassSetup)
        function setConnection(testCase)
            testCase.hed = HedToolsPython('8.2.0');
        end
    end

    methods (Test)

            
        function testValidString(testCase)
            % Test valid check warnings no warnings
            issues = testCase.hed.validate_hedtags('Red, Blue', true);
            testCase.verifyEqual(strlength(issues), 0);
       
            % Test valid check warnings has warnings
            issues = testCase.hed.validate_hedtags('Red, Blue/Apple', ...
                true);
            testCase.verifyGreaterThan(strlength(issues), 0);

             % Test valid no check warnings has warnings
            issues = testCase.hed.validate_hedtags('Red, Blue/Apple', ...
                false);
            testCase.verifyEqual(strlength(issues), 0);

             % Test with extension and no check warnings
            issues = testCase.hed.validate_hedtags('Red, Blue/Apple', ...
                false);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid HED string with ext has no errors.');
        end

        function testInvalidString(testCase)
            % Test check warnings with errors
            issues1 = testCase.hed.validate_hedtags(...
                 'Red, Blue/Apple, Green, Blech', true);
            testCase.verifyGreaterThan(strlength(issues1), 0);
            
            % Test no check warnings with errors
            issues2 = testCase.hed.validate_hedtags(...
                 'Red, Blue/Apple, Green, Blech', false);
            testCase.verifyGreaterThan(strlength(issues2), 0);
        end

        function testListMixedStrings(testCase)
            % Test pass cell array (should only take strings)
            testCase.verifyError(@() testCase.hed.validate_hedtags( ...
                {'Red, Blue/Apple', 'Green, Blech'}, true), ...
                'HedToolsPython:validate_hedtags');
            testCase.verifyError(@() testCase.hed.validate_hedtags( ...
                {'Red, Blue/Apple', 'Green, Blech'}, false), ...
                'HedToolsPython:validate_hedtags');
        end


        % % Todo: test with and without schema
        % Todo: test with definitions

    end
end