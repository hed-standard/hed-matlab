classdef TestGetEventTable < matlab.unittest.TestCase

    properties
        hedModule
        eventsPath
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hedModule = py.importlib.import_module('hed'); 
            [curDir, ~, ~] = fileparts(mfilename("fullpath"));
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep);
            testCase.eventsPath = fullfile(dataPath, filesep, ...
                 'eeg_ds003645s_hed_demo', filesep, 'sub-002', ...
                filesep, 'ses-1', filesep, 'EEG', filesep,...
                'sub-002_ses-1_task-FacePerception_run-1_events.tsv'); 
        end
    end

    methods (Test)

        function testSimpleVersion(testCase)
            % Test single version
            events = fileread(testCase.eventsPath);
            util =  py.importlib.import_module('hed.tools.analysis.annotation_util'); 
            tab = util.str_to_tabular(events);
            testCase.assertTrue(py.isinstance(tab, ...
                testCase.hedModule.TabularInput))
        end


    end
end