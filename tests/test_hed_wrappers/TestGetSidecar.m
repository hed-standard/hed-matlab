classdef TestGetSidecar < matlab.unittest.TestCase

    properties
        hedModule
        jsonPath
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hedModule = py.importlib.import_module('hed');
            myPath = mfilename("fullpath");  
            [curDir, ~, ~] = fileparts(myPath);
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep);
            testCase.jsonPath = fullfile(dataPath, 'eeg_ds003645s_hed_demo', ...
                filesep, 'task-FacePerception_events.json');
 
           
        end
    end

    methods (Test)

        function testSimple(testCase)
            % Test single version
            sidecar = testCase.hedModule.Sidecar(testCase.jsonPath);
            assertTrue(testCase, py.isinstance(sidecar, ...
                 testCase.hedModule.Sidecar), 'Object not a Sidecar.');
            sidecarObj = getSidecar(sidecar);
            assertTrue(testCase, py.isinstance(sidecarObj, ...
                       testCase.hedModule.Sidecar), ...
                       'Object not a Sidecar after getSidecar.');
            jsonString = fileread(testCase.jsonPath);
            sidecarObj1 = getSidecar(jsonString);
            testCase.verifyTrue(py.isinstance(sidecarObj1, ...
                       testCase.hedModule.Sidecar), ...
                       'Object not a Sidecar after getSidecar to string.');
            sidecarObj2 = getSidecar(jsondecode(jsonString));
            assertTrue(testCase, py.isinstance(sidecarObj2, ...
                       testCase.hedModule.Sidecar), ...
                       'Object not a Sidecar after getSidecar to struct.');
        end

        function testNone(testCase)
    
            % Test single version
            testCase.verifyError(@() getSidecar([]), 'getSidecar:EmptySidecar');
        end

    end
end