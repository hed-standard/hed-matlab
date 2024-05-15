classdef TestValidateHedtags < matlab.unittest.TestCase

    properties
        hmod
        schema
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hmod = py.importlib.import_module('hed');
            testCase.schema = get_schema_obj('8.2.0');
        end
    end

    methods (Test)

        function testBasicValid(testCase)
            % Test a simple string
            issues = validate_hedtags('Red, Blue', ...
                 testCase.schema, true, struct());
            testCase.verifyEqual(strlength(issues), 0, ...
                                 'Valid HED string has issues.');
            % Test with extension and check for warnings is true
            issues = validate_hedtags('Red, Blue/Apple', ...
                testCase.schema, true, struct());
            testCase.verifyGreaterThan(strlength(issues), 0, ...
                'Valid HED string with ext has warning.');

            % Test with extension and check for warnings is false
            issues = validate_hedtags('Red, Blue/Apple', ...
                testCase.schema, false, struct());
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid HED string with ext has no errors.');
        end

        function testBasicInvalid(testCase)
            % Test a simple string
            issues = validate_hedtags('Red, Yikes', testCase.schema, ...
                true, struct());
            testCase.verifyGreaterThan(strlength(issues), 0, ...
                'Invalid HED string has no issues.');
            % Test with extension and check for warnings is true
            issues = validate_hedtags('Red, Blue/Apple, Yikes', ...
                testCase.schema, false, struct());
            testCase.verifyGreaterThan(strlength(issues), 0, ...
                'Invalid HED string hs no issues.');
        end

        % Todo: test with and without schema
        % Todo: test with definitions

    end
end