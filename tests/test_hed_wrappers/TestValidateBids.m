classdef TestValidateBids < matlab.unittest.TestCase

    properties
        hmod
        data_root
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
            testCase.hmod = py.importlib.import_module('hed');
            [cur_dir, ~, ~] = fileparts(mfilename("fullpath"));
            testCase.data_root = fullfile(cur_dir, filesep, '..', ...
                filesep, '..', filesep, 'data', filesep, ...
                'eeg_ds003645s_hed_demo');
        end
    end

    methods (Test)

        function testValidEvents(testCase)
            % Test on valid Sidecar
            issue_string = validate_bids(testCase.data_root);
            testCase.verifyTrue(isempty(char(issue_string)));
        end    

    end
end