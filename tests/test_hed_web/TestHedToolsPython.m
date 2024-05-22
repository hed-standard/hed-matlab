classdef TestHedToolsPython < matlab.unittest.TestCase

    properties
        hed
        hmod
        goodSidecarPath
        badSidecarPath
        goodEventsPath
        eventsStruct
        eventsStructNoOnset
        sidecarStructGood
    end

    methods (TestClassSetup)
        function setUp(testCase)
            testCase.hmod = py.importlib.import_module('hed');
            testCase.hed = HedToolsPython('8.2.0');
            [curDir, ~, ~] = fileparts(mfilename("fullpath"));
            dataPath = fullfile(curDir, filesep, '..', filesep, '..', ...
                filesep, 'data', filesep);
            testCase.goodSidecarPath = fullfile(dataPath,  ...
                'eeg_ds003645s_hed_demo',filesep, ...
                'task-FacePerception_events.json');
            testCase.badSidecarPath = fullfile(dataPath, filesep,  ...
                'other_data',filesep, 'both_types_events_errors.json');
            testCase.goodEventsPath = fullfile(dataPath, ...
                filesep, 'eeg_ds003645s_hed_demo', filesep, 'sub-002', ...
                filesep, 'ses-1', filesep, 'eeg', filesep,...
                'sub-002_ses-1_task-FacePerception_run-1_events.tsv');
            events(3) = struct('onset', 3.2, 'duration', NaN, ...
                'latency', 6234, 'response', 2.1, 'type', 'apple');
            events(2) = struct('onset', 2.2, 'duration', NaN, ...
                'latency', 5234, 'response', NaN, 'type', 'pear');
            events(1) = struct('onset', 1.1, 'duration', NaN,  'latency', 4234, ...
                'response', 1.5, 'type', 'banana');
            testCase.eventsStruct = events;
            testCase.eventsStructNoOnset = rmfield(events, 'onset');
            struct1 = struct('apple', 'Sensory-event', ...
                'pear', 'Agent-action', 'banana', 'Sensory-event, Red');
            testCase.sidecarStructGood = struct('type', struct1);
        end
    end

    methods (Test)
        function testGetSidecarObjSidecarIn(testCase)
            % Test with incoming sidecar
            sidecar = testCase.hmod.Sidecar(testCase.goodSidecarPath);
            testCase.assertTrue(...
                py.isinstance(sidecar, testCase.hmod.Sidecar));
            sidecarObj = HedToolsPython.getSidecarObj(sidecar);
            testCase.assertTrue(...
                py.isinstance(sidecarObj, testCase.hmod.Sidecar));
        end

        function testGetSidecarObjCharIn(testCase)
            % Test with incoming sidecar string
            jsonChar = fileread(testCase.goodSidecarPath);
            testCase.verifyTrue(ischar(jsonChar));
            sidecarObj = HedToolsPython.getSidecarObj(jsonChar);
            testCase.verifyTrue(...
                py.isinstance(sidecarObj, testCase.hmod.Sidecar));
        end

        function testGetSidecarObjStringIn(testCase)
            % Test with incoming sidecar string
            jsonString = string(fileread(testCase.goodSidecarPath));
            testCase.verifyTrue(isstring(jsonString));
            sidecarObj = testCase.hed.getSidecarObj(jsonString);
            testCase.verifyTrue(py.isinstance(sidecarObj, ...
                testCase.hmod.Sidecar));
        end

        function testGetSidecarObjStructIn(testCase)
            % Test with incoming sidecar struct
            jsonStruct = jsondecode(fileread(testCase.goodSidecarPath));
            testCase.verifyTrue(isstruct(jsonStruct));
            sidecarObj = HedToolsPython.getSidecarObj(jsonStruct);
            testCase.assertTrue(py.isinstance(sidecarObj, ...
                testCase.hmod.Sidecar));
        end

        function testBadInputs(testCase)
            % Test for error bad inputs
            testCase.verifyError(@() get_sidecar_obj([]), ...
                'get_sidecar_obj:BadInputFormat');
        end

        function testGetTabularInputSimple(testCase)
            % Test tabular input with onset column and sidecar
            events = fileread(testCase.goodEventsPath);
            sidecar = fileread(testCase.goodSidecarPath);
            tabularObj = HedToolsPython.getTabularObj(events, sidecar);
            testCase.assertTrue(py.isinstance(tabularObj, ...
                testCase.hmod.TabularInput));
        end

        function testGetTabularInputNoSidecar(testCase)
            % Test tabular input with no sidecar
            events = fileread(testCase.goodEventsPath);
            sidecar = py.None;
            tabularObj = get_tabular_obj(events, sidecar);
            testCase.assertTrue(py.isinstance(tabularObj, ...
                testCase.hmod.TabularInput));
        end

        function testEventsValidNoSidecar(testCase)
            % Valid char sidecar should not have errors or warnings
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsChar), '', false);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid char events no sidecar should not have errors.');
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsChar), py.None, true);
            testCase.verifyGreaterThan(strlength(issueString), 0, ...
                'Valid char events no sidecar has warnings.');
        end

        function testEventsValidGoodSidecar(testCase)
            % Valid char events should not have errors or warnings
            sidecarChar = fileread(testCase.goodSidecarPath);
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsChar), ...
                sidecarChar, false);
            testCase.verifyEqual(strlength(issueString), 0);
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsChar), ...
                sidecarChar, true);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid string events should not have errors or warnings
            eventsString = string(eventsChar);
            testCase.verifyTrue(isstring(eventsString))
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsString), sidecarChar, false);
            testCase.verifyEqual(strlength(issueString), 0');
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsString), sidecarChar, true);
            testCase.verifyEqual(strlength(issueString), 0);
        end

        function testEventsValidBadSidecar(testCase)
            % Valid char sidecar should not have errors or warnings
            sidecarChar = fileread(testCase.badSidecarPath);
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))
            issueString = testCase.hed.validateEvents(eventsChar, ...
                sidecarChar, false);
            testCase.verifyGreaterThan(strlength(issueString), 0);
            issueString = testCase.hed.validateEvents(eventsChar, ...
                sidecarChar, true);
            testCase.verifyGreaterThan(strlength(issueString), 0);


            % Valid string events should not have errors or warnings
            eventsString = string(eventsChar);
            testCase.verifyTrue(isstring(eventsString))
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsString), sidecarChar, false);
            testCase.verifyGreaterThan(strlength(issueString), 0');
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsString), sidecarChar, true);
            testCase.verifyGreaterThan(strlength(issueString), 0);

        end

        function testEventsStructWithOnset(testCase)
            % Valid struct with onset no sidecar warnings but no errors
            eventsRectified = ...
                rectify_events(testCase.eventsStruct);
            testCase.verifyTrue(isstruct(eventsRectified));
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), ...
                testCase.sidecarStructGood, true);
            testCase.verifyGreaterThan(strlength(issueString),  0);

            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), ...
                testCase.sidecarStructGood, false);
            testCase.verifyEqual(strlength(issueString),  0);

            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), '', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), '', false);
            testCase.verifyEqual(strlength(issueString), 0);
        end

        function testEventsStructNoOnset(testCase)
            % Valid struct with onset no sidecar warnings but no errors
            eventsRectified = ...
                rectify_events(testCase.eventsStructNoOnset, 100);
            testCase.verifyTrue(isstruct(eventsRectified));
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), ...
                testCase.sidecarStructGood, true);
            testCase.verifyGreaterThan(strlength(issueString),  0);

            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), ...
                testCase.sidecarStructGood, false);
            testCase.verifyEqual(strlength(issueString),  0);

            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), '', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), '', false);
            testCase.verifyEqual(strlength(issueString), 0);
        end

        function testEventsStructNoOnsetNoSampling(testCase)
            % % Valid struct events no onset should not have errors or warnings
            testCase.verifyError( ...
                @ ()rectify_events(testCase.eventsStructNoOnset), ...
                'rectify_events:NeedSamplingRate');
            % sidecarStruct = jsondecode(sidecarChar);
            % testCase.verifyTrue(isstruct(sidecarStruct))
            % issueString = testCase.hed.validateSidecar( ...
            %     HedTools.formatSidecar(sidecarStruct), false);
            % testCase.verifyEqual(strlength(issueString), 0, ...
            %     'Valid char sidecar should not have errors.');
            % issueString = testCase.hed.validateSidecar(...
            %     HedTools.formatSidecar(sidecarStruct), true);
            % testCase.verifyEqual(strlength(issueString), 0, ...
            %     'Valid char sidecar should not have warnings.');
        end
            
        function testSidecarValid(testCase)
            % Valid char sidecar should not have errors or warnings
            sidecarChar = fileread(testCase.goodSidecarPath);
            testCase.verifyTrue(ischar(sidecarChar))
            issueString = testCase.hed.validateSidecar( ...
                HedTools.formatSidecar(sidecarChar), false);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid char sidecar should not have errors.');
            issueString = testCase.hed.validateSidecar(...
                HedTools.formatSidecar(sidecarChar), true);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid char sidecar should not have warnings.');

            % Valid string sidecar should not have errors or warnings
            sidecarString = string(sidecarChar);
            testCase.verifyTrue(isstring(sidecarString))
            issueString = testCase.hed.validateSidecar( ...
                HedTools.formatSidecar(sidecarString), false);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid char sidecar should not have errors.');
            issueString = testCase.hed.validateSidecar(...
                HedTools.formatSidecar(sidecarString), true);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid char sidecar should not have warnings.');

            % Valid struct sidecar should not have errors or warnings
            sidecarStruct = jsondecode(sidecarChar);
            testCase.verifyTrue(isstruct(sidecarStruct))
            issueString = testCase.hed.validateSidecar( ...
                HedTools.formatSidecar(sidecarStruct), false);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid char sidecar should not have errors.');
            issueString = testCase.hed.validateSidecar(...
                HedTools.formatSidecar(sidecarStruct), true);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid char sidecar should not have warnings.');
        end

        function testSidecarInvalid(testCase)
            % Invalid char sidecar should have errors
            sidecarChar = fileread(testCase.badSidecarPath);
            testCase.verifyTrue(ischar(sidecarChar))
            issueString = testCase.hed.validateSidecar( ...
                HedTools.formatSidecar(sidecarChar), false);
            testCase.verifyGreaterThan(strlength(issueString), 0, ...
                'Invalid char sidecar should not have errors.');
            issueString = testCase.hed.validateSidecar(...
                HedTools.formatSidecar(sidecarChar), true);
            testCase.verifyGreaterThan(strlength(issueString), 0, ...
                'Invalid char sidecar should not have warnings.');

            % Invalid string sidecar should have errors or warnings
            sidecarString = string(sidecarChar);
            testCase.verifyTrue(isstring(sidecarString))
            issueString = testCase.hed.validateSidecar( ...
                HedTools.formatSidecar(sidecarString), false);
            testCase.verifyGreaterThan(strlength(issueString), 0, ...
                'Invalid char sidecar should have errors.');
            issueString = testCase.hed.validateSidecar(...
                HedTools.formatSidecar(sidecarString), true);
            testCase.verifyGreaterThan(strlength(issueString), 0, ...
                'Invalid char sidecar should have warnings.');

            % Inalid struct sidecar should not have errors or warnings
            sidecarStruct = jsondecode(sidecarChar);
            testCase.verifyTrue(isstruct(sidecarStruct))
            issueString = testCase.hed.validateSidecar( ...
                HedTools.formatSidecar(sidecarStruct), false);
            testCase.verifyGreaterThan(strlength(issueString), 0, ...
                'Invalid char sidecar should have errors.');
            issueString = testCase.hed.validateSidecar(...
                HedTools.formatSidecar(sidecarStruct), true);
            testCase.verifyGreaterThan(strlength(issueString), 0, ...
                'Invalid char sidecar should have warnings.');
        end
       
        function testTagsValid(testCase)
            % Test valid check warnings no warnings
            issues = testCase.hed.validateTags('Red, Blue', true);
            testCase.verifyEqual(strlength(issues), 0);

            % Test valid check warnings has warnings
            issues = testCase.hed.validateTags('Red, Blue/Apple', ...
                true);
            testCase.verifyGreaterThan(strlength(issues), 0);

            % Test valid no check warnings has warnings
            issues = testCase.hed.validateTags('Red, Blue/Apple', ...
                false);
            testCase.verifyEqual(strlength(issues), 0);

            % Test with extension and no check warnings
            issues = testCase.hed.validateTags('Red, Blue/Apple', ...
                false);
            testCase.verifyEqual(strlength(issues), 0, ...
                'Valid HED string with ext has no errors.');
        end

        function testTagsInvalid(testCase)
            % Test check warnings with errors
            issues1 = testCase.hed.validateTags(...
                'Red, Blue/Apple, Green, Blech', true);
            testCase.verifyGreaterThan(strlength(issues1), 0);

            % Test no check warnings with errors
            issues2 = testCase.hed.validateTags(...
                'Red, Blue/Apple, Green, Blech', false);
            testCase.verifyGreaterThan(strlength(issues2), 0);
        end

        function testTagsInvalidFormat(testCase)
            % Test pass cell array (should only take strings)
            testCase.verifyError(@() testCase.hed.validateTags( ...
                {'Red, Blue/Apple', 'Green, Blech'}, true), ...
                'HedToolsPythonValidateHedTags:InvalidHedTagInput');
            testCase.verifyError(@() testCase.hed.validateTags( ...
                {'Red, Blue/Apple', 'Green, Blech'}, false), ...
                'HedToolsPythonValidateHedTags:InvalidHedTagInput');
        end

    end
end