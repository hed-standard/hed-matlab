classdef TestGetEventTable < matlab.unittest.TestCase

    properties
        hedModule
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hedModule = py.importlib.import_module('hed');
        end
    end

    methods (Test)

        function testSimpleVersion(testCase)
            % Test single version
            hedVersion = '8.2.0';
            hedSchema = getHedSchema(hedVersion);
            assertTrue(testCase, py.isinstance(hedSchema, ...
                       testCase.hedModule.schema.HedSchema), ...
                       'The object is not an instance of HedSchema.');
            version = char(hedSchema.version);
            testCase.verifyEqual(version, '8.2.0', ...
                                 'Created schema has incorrect version.');
        end

        function testMultipleVersions(testCase)
            % Test complex version with prefix and partnered library
            hedVersion = py.list({'ts:8.2.0', 'score_1.1.0'});
            hedSchema = getHedSchema(hedVersion);
            assertTrue(testCase, py.isinstance(hedSchema, ...
                       testCase.hedModule.schema.HedSchemaGroup), ...
                       'The object is not an instance of HedSchemaGroup.');
            versions = cell(hedSchema.get_schema_versions());
            testCase.verifyEqual(char(versions{1}), 'ts:8.2.0', ...
                                 'Created schema has incorrect version.');
            testCase.verifyEqual(char(versions{2}), 'score_1.1.0', ...
                                 'Created schema has incorrect version.');
        end
    end
end