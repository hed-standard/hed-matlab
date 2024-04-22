classdef TestGetSidecar < matlab.unittest.TestCase

    properties
        hedModule
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hedModule = py.importlib.import_module('hed');
                       testCase.hedModule = py.importlib.import_module('hed');
            testCase.hedSchema = getHedSchema('8.2.0');
                myPath = mfilename("fullpath");  
            [curDir, ~, ~] = fileparts(myPath);
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep);
            testCase.goodPath = fullfile(dataPath, 'eeg_ds003645s_hed_demo', ...
                filesep, 'task-FacePerception_events.json');
            testCase.badPath = fullfile(dataPath, filesep, 'other_data', ...
                'both_types_events_errors.json');
            testCase.goodSidecar = ...
                testCase.hedModule.Sidecar(testCase.goodPath);
            testCase.badSidecar = ...
                testCase.hedModule.Sidecar(testCase.badPath);
        end
    end
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