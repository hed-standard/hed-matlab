classdef TestValidateString < matlab.unittest.TestCase

    properties
        hedModule
        hedSchema
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hedModule = py.importlib.import_module('hed');
            testCase.hedSchema = getHedSchema('8.2.0');
        end
    end

    methods (Test)

        function testBasicValid(testCase)
            % Test a simple string
            issues = validateString('Red, Blue', testCase.hedSchema, ...
                                     true, struct());
            testCase.verifyEqual(strlength(issues), 0, ...
                                 'Valid HED string has issues.');
            % Test with extension and check for warnings is true
            issues = validateString('Red, Blue/Apple', ...
                testCase.hedSchema, true, struct());
            testCase.verifyGreaterThan(strlength(issues), 0, ...
                'Valid HED string with ext has warning.');

            % Test with extension and check for warnings is false
            issues = validateString('Red, Blue/Apple', ...
                testCase.hedSchema, false, struct());
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid HED string with ext has no errors.');
        end

        function testBasicInvalid(testCase)
            % Test a simple string
            issues = validateString('Red, Yikes', testCase.hedSchema, ...
                true, struct());
            testCase.verifyGreaterThan(strlength(issues), 0, ...
                'Invalid HED string has no issues.');
            % Test with extension and check for warnings is true
            issues = validateString('Red, Blue/Apple, Yikes', ...
                testCase.hedSchema, false, struct());
            testCase.verifyGreaterThan(strlength(issues), 0, ...
                'Invalid HED string hs no issues.');
        end

        % Todo: test with and without schema
        % Todo: test with definitions

    end
end