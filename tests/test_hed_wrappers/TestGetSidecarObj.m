classdef TestGetSidecarObj < matlab.unittest.TestCase

    properties
        hmod
        json_path
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hmod = py.importlib.import_module('hed');
            [curDir, ~, ~] = fileparts(mfilename("fullpath"));
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep);
            testCase.json_path = fullfile(dataPath, 'eeg_ds003645s_hed_demo', ...
                filesep, 'task-FacePerception_events.json');         
        end
    end

    methods (Test)

        function testSidecarIn(testCase)
            % Test with incoming sidecar
            sidecar = testCase.hmod.Sidecar(testCase.json_path);
            testCase.assertTrue(...
                py.isinstance(sidecar, testCase.hmod.Sidecar));
            sidecar_obj = get_sidecar_obj(sidecar);
            testCase.assertTrue(...
                py.isinstance(sidecar_obj, testCase.hmod.Sidecar));
        end

        function testCharIn(testCase)
            % Test with incoming sidecar string
            json_char = fileread(testCase.json_path);
            testCase.verifyTrue(ischar(json_char));
            sidecar_obj = get_sidecar_obj(json_char);
            testCase.verifyTrue(...
                py.isinstance(sidecar_obj, testCase.hmod.Sidecar));
        end

        function testStringIn(testCase)
            % Test with incoming sidecar string
            json_string = string(fileread(testCase.json_path));
            testCase.verifyTrue(isstring(json_string));
            sidecar_obj = get_sidecar_obj(json_string);
            testCase.verifyTrue(...
                py.isinstance(sidecar_obj, testCase.hmod.Sidecar));
        end

        function testStructIn(testCase)
            % Test with incoming sidecar struct
            json_struct = jsondecode(fileread(testCase.json_path));
            testCase.verifyTrue(isstruct(json_struct));
            sidecar_obj = get_sidecar_obj(json_struct);
            testCase.assertTrue(...
                py.isinstance(sidecar_obj, testCase.hmod.Sidecar));
        end

        function testBadInputs(testCase)
            % Test for error bad inputs
            testCase.verifyError(@() get_sidecar_obj([]), ...
                'get_sidecar_obj:BadInputFormat');
        end

    end
end