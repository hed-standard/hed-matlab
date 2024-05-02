classdef TestGetSchemaObj < matlab.unittest.TestCase

    properties
        hmod
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hmod = py.importlib.import_module('hed');
        end
    end

    methods (Test)

        function testSimpleVersion(testCase)
            % Test single version
            version = '8.2.0';
            schema = get_schema_obj(version);
            assertTrue(testCase, py.isinstance(schema, ...
                       testCase.hmod.schema.HedSchema), ...
                       'The object is not an instance of HedSchema.');
            version = char(schema.version);
            testCase.verifyEqual(version, '8.2.0', ...
                                 'Created schema has incorrect version.');
        end

        function testMultipleVersions(testCase)
            % Test complex version with prefix and partnered library
            version = {'ts:8.2.0', 'score_1.1.0'};
            schema = get_schema_obj(version);
            assertTrue(testCase, py.isinstance(schema, ...
                       testCase.hmod.schema.HedSchemaGroup), ...
                       'The object is not an instance of HedSchemaGroup.');
            versions = cell(schema.get_schema_versions());
            testCase.verifyEqual(char(versions{1}), 'ts:8.2.0', ...
                                 'Created schema has incorrect version.');
            testCase.verifyEqual(char(versions{2}), 'score_1.1.0', ...
                                 'Created schema has incorrect version.');
        end

        function testNone(testCase)
            % Test for error when no schema
            testCase.verifyError(@() get_schema_obj(''),...
                'MATLAB:Python:PyException');
        end
    end
end