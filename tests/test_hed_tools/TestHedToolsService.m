classdef TestHedToolsService < matlab.unittest.TestCase

    properties
       hed
       goodSidecarPath
       badSidecarPath
       goodEventsPath
       eventsStruct
       eventsStructNoOnset
       sidecarStructGood
    end

    methods (TestClassSetup)
        function setUp(testCase)
            %testCase.hed = ...
            %   HedToolsService('8.4.0', 'https://hedtools.org/hed');
            % testCase.hed = ...
            %     HedToolsService('8.4.0', 'https://hedtools.org/hed_dev');
            testCase.hed = ...
               HedToolsService('8.4.0', 'http://127.0.0.1:5000');
            %testCase.hed = ...
            %   HedToolsService('8.3.0', 'http://192.168.0.24/hed');
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

        function testCreateConnection(testCase)
            % Test a simple string
            hed1 = HedToolsService('8.2.0', 'https://hedtools.org/hed_dev');
            testCase.verifyTrue(isa(hed1, 'HedToolsService'));
        end

        function testGenerateSidecar(testCase)
            % Valid char events should not have errors or warnings
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))

            % no types, no context, no replace
            sidecar = testCase.hed.generateSidecar(eventsChar, ...
               {'trial', 'rep_lag', 'stim_file'}, ...
               {'onset', 'duration', 'sample'});
            testCase.verifyTrue(ischar(sidecar));
            sideStruct = jsondecode(sidecar);
            testCase.verifyFalse(isfield(sideStruct, 'onset'));
            testCase.verifyTrue(isstruct(sideStruct.event_type.HED));
            testCase.verifyTrue(ischar(sideStruct.trial.HED));
        end

        function testGetHedAnnotations(testCase)
            % Valid char events should not have errors or warnings
            sidecarChar = fileread(testCase.goodSidecarPath);
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))

            % no types, no context, no replace
            annotations = testCase.hed.getHedAnnotations(eventsChar, ...
                sidecarChar, 'removeTypesOn', true, ...
                'includeContext', false, 'replaceDefs', false);
            testCase.verifyEqual(length(annotations), 199);
            testCase.verifyEmpty(annotations{195});
            data1_str = strjoin(annotations, '\n');
            testCase.verifyEqual(length(data1_str), 10547);

            % With context, no remove, no replace         
            annotations = testCase.hed.getHedAnnotations(eventsChar, ...
                sidecarChar, 'removeTypesOn', false, ...
                'includeContext', true, 'replaceDefs', false);
            testCase.verifyEqual(length(annotations), 199);        
            testCase.verifyGreaterThan(length(annotations{195}), 0);
            data2_str = strjoin(annotations, '\n');
            testCase.verifyGreaterThan(length(data2_str), length(data1_str));

            % With context, remove, no replace
            annotations = testCase.hed.getHedAnnotations(eventsChar, ...
                sidecarChar, 'removeTypesOn', true, ...
                'includeContext', true, 'replaceDefs', false);
            testCase.verifyEqual(length(annotations), 199);
            data3_str = strjoin(annotations, '\n');
            testCase.verifyGreaterThan(length(data2_str), length(data3_str));

            % With context, remove, replace
            annotations = testCase.hed.getHedAnnotations(eventsChar, ...
                sidecarChar, 'removeTypesOn', true, ...
                'includeContext', true, 'replaceDefs', true);
            testCase.verifyEqual(length(annotations), 199);
            data4_str = strjoin(annotations, '\n');
            testCase.verifyGreaterThan(length(data4_str), length(data3_str));
        end   

        function testGetHedAnnotationsInvalid(testCase)
            events = fileread(testCase.goodEventsPath);
            sidecar = fileread(testCase.badSidecarPath);
            testCase.verifyError( ...
                @ ()testCase.hed.getHedAnnotations(events, sidecar, ...
                'removeTypesOn', true, ...
                'includeContext', true, 'replaceDefs', false), ...
                'HedToolsServiceGetHedAnnotations:InvalidData');
        end

        function testSearchHed(testCase)
            % Simple tests of HED queries on valid strings
            annotations = {'Red', 'Sensory-event', 'Blue'};
            queries1 = {'Sensory-event'};
            factors1 = testCase.hed.searchHed(annotations, queries1);
            testCase.verifyEqual(length(factors1), 3);
            testCase.verifyEqual(factors1(2), 1);

            % Test 2 queries on 3 strings.
            queries2 = {'Sensory-event', 'Red'};
            factors2 = testCase.hed.searchHed(annotations, queries2);
            testCase.verifyEqual(size(factors2), [3, 2])
        end

        function testEventsValidNoSidecar(testCase)
            % Valid char sidecar should not have errors or warnings
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))
            issueString = testCase.hed.validateEvents(eventsChar, '');
            testCase.verifyEqual(length(issueString), 0, ...
                'Valid char events no sidecar should not have errors.');
            issueString = testCase.hed.validateEvents(eventsChar, '', ...
                'checkWarnings', true);
            testCase.verifyGreaterThan(length(issueString), 0, ...
                'Valid char events no sidecar has warnings.');
        end

        function testEventsValidGoodSidecar(testCase)
            % Valid char events should not have errors or warnings
            sidecarChar = fileread(testCase.goodSidecarPath);
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))
            issueString = testCase.hed.validateEvents(eventsChar, ...
                sidecarChar, 'checkWarnings', false);
            testCase.verifyEqual(length(issueString), 0);
            issueString = testCase.hed.validateEvents(...
                eventsChar, sidecarChar, 'checkWarnings', true);
            testCase.verifyEqual(length(issueString), 0);

            % Valid string events should not have errors or warnings
            eventsString = string(eventsChar);
            testCase.verifyTrue(isstring(eventsString))
            issueString = testCase.hed.validateEvents(...
                eventsString, sidecarChar, 'checkWarnings', false);
            testCase.verifyEqual(length(issueString), 0);
            issueString = testCase.hed.validateEvents(...
                eventsString, sidecarChar, 'checkWarnings', true);
            testCase.verifyEqual(length(issueString), 0);
        end

        function testEventsValidBadSidecar(testCase)
            % Valid char sidecar should not have errors or warnings
            sidecarChar = fileread(testCase.badSidecarPath);
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))
            issueString = testCase.hed.validateEvents(eventsChar, ...
                sidecarChar, 'checkWarnings', false);
            testCase.verifyGreaterThan(strlength(issueString), 0);
            issueString = testCase.hed.validateEvents(eventsChar, ...
                sidecarChar, 'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);


            % Valid string events should not have errors or warnings
            eventsString = string(eventsChar);
            testCase.verifyTrue(isstring(eventsString))
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsString), sidecarChar, ...
                    'checkWarnings', false);
            testCase.verifyGreaterThan(strlength(issueString), 0);
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsString), sidecarChar, ...
                'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);

        end

        function testEventsValidStructWithOnset(testCase)
            % Valid struct with onset no sidecar warnings but no errors
            eventsRectified = ...
                rectify_events(testCase.eventsStruct);
            testCase.verifyTrue(isstruct(eventsRectified));
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), ...
                testCase.sidecarStructGood, 'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString),  0);

            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), ...
                testCase.sidecarStructGood, 'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString),  0);

            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), '', ...
                'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), '', ...
                'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0);
        end

        function testEventsValidStructNoOnset(testCase)
            % Valid struct with onset no sidecar warnings but no errors
            eventsRectified = ...
                rectify_events(testCase.eventsStructNoOnset, 100);
            testCase.verifyTrue(isstruct(eventsRectified));
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), ...
                testCase.sidecarStructGood, ...
                'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString),  0);

            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), ...
                testCase.sidecarStructGood, 'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString),  0);

            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), '', ...
                'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsRectified), '', ...
                'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0);
        end

        function testEventsValidStructNoOnsetNoSampling(testCase)
            % Unrectified struct events no onset.
            issueString = testCase.hed.validateEvents( ...
                testCase.eventsStructNoOnset, ...
                testCase.sidecarStructGood, ...
                'checkWarnings', false);
            testCase.verifyEmpty(issueString);
            issueString = testCase.hed.validateEvents( ...
                testCase.eventsStructNoOnset, ...
                testCase.sidecarStructGood, 'checkWarnings', true);
            testCase.verifyGreaterThan(length(issueString), 0);
        end

        function testEventsInvalid(testCase)
            sidecarChar = fileread(testCase.badSidecarPath);
            eventsChar = fileread(testCase.goodEventsPath);
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsChar), sidecarChar, ...
                'checkWarnings', true);
            testCase.verifyTrue(ischar(issueString));
            testCase.verifyGreaterThan(length(issueString), 0);
        end

        function testSidecarValid(testCase)
            % Valid char sidecar should not have errors 
            sidecarChar = fileread(testCase.goodSidecarPath);
            testCase.verifyTrue(ischar(sidecarChar))
            issueString = testCase.hed.validateSidecar( ...
                sidecarChar, 'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid char sidecar should not have errors or warnings
            issueString = testCase.hed.validateSidecar(...
                sidecarChar, 'checkWarnings', true);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid string sidecar should not have errors
            sidecarString = string(sidecarChar);
            testCase.verifyTrue(isstring(sidecarString))
            issueString = testCase.hed.validateSidecar( ...
                sidecarString, 'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid char sidecar should not have errors or warnings.
            issueString = testCase.hed.validateSidecar(...
                sidecarString, 'checkWarnings', true);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid struct sidecar should not have errors
            sidecarStruct = jsondecode(sidecarChar);
            testCase.verifyTrue(isstruct(sidecarStruct))
            issueString = testCase.hed.validateSidecar( ...
                sidecarStruct, 'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid struct sidecar should not have errors or warnings
            issueString = testCase.hed.validateSidecar(...
                sidecarStruct, 'checkWarnings', true);
            testCase.verifyEqual(strlength(issueString), 0);
        end

        function testSidecarInvalid(testCase)
            % Invalid char sidecar should have errors
            sidecarChar = fileread(testCase.badSidecarPath);
            testCase.verifyTrue(ischar(sidecarChar))
            issueString = testCase.hed.validateSidecar( ...
                sidecarChar, 'checkWarnings', false);
            testCase.verifyGreaterThan(strlength(issueString), 0);

             % Invalid char sidecar should have errors with warning on
            issueString = testCase.hed.validateSidecar(...
                sidecarChar, 'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);

            % Invalid string sidecar should have errors
            sidecarString = string(sidecarChar);
            testCase.verifyTrue(isstring(sidecarString))
            issueString = testCase.hed.validateSidecar( ...
                sidecarString, 'checkWarnings', false);
            testCase.verifyGreaterThan(strlength(issueString), 0);

            % Invalid string sidecar should have errors with warning on
            issueString = testCase.hed.validateSidecar(...
                sidecarString, 'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);

            % Invalid struct sidecar should not have errors or warnings
            sidecarStruct = jsondecode(sidecarChar);
            testCase.verifyTrue(isstruct(sidecarStruct))
            issueString = testCase.hed.validateSidecar( ...
                sidecarStruct, 'checkWarnings', false);
            testCase.verifyGreaterThan(strlength(issueString), 0);

            % Invalid struct sidecar should have errors with warning on
            issueString = testCase.hed.validateSidecar(...
                sidecarStruct, 'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);
        end

        function testTagsValid(testCase)
            % Test valid check warnings no warnings
            issues = testCase.hed.validateTags('Red, Blue', ...
                'checkWarnings', true);
            testCase.verifyEqual(length(issues), 0);

            % Test valid check warnings has warnings
            issues = testCase.hed.validateTags('Red, Blue/Apple', ...
                'checkWarnings', true);
            testCase.verifyGreaterThan(length(issues), 0);

            % Test valid no check warnings has no warnings
            issues = testCase.hed.validateTags('Red, Blue/Apple', ...
                'checkWarnings', false);
            testCase.verifyEqual(length(issues), 0);

            % Test with extension and no check warnings
            issues = testCase.hed.validateTags('Red, Blue/Apple', ...
                'checkWarnings', false);
            testCase.verifyEqual(length(issues), 0);
        end

        function testTagsInvalid(testCase)
            % Test check warnings with errors
            issues1 = testCase.hed.validateTags(...
                'Red, Blue/Apple, Green, Blech', 'checkWarnings', true);
            testCase.verifyGreaterThan(length(issues1), 0);

            % Test no check warnings with errors
            issues2 = testCase.hed.validateTags(...
                'Red, Blue/Apple, Green, Blech', 'checkWarnings', false);
            testCase.verifyGreaterThan(length(issues2), 0);
        end

        function testTagsInvalidFormat(testCase)
            % Test pass cell array (should only take strings)
            testCase.verifyError(@() testCase.hed.validateTags( ...
                {'Red, Blue/Apple', 'Green, Blech'}, ...
                'checkWarnings', true), ...
                'HedToolsServiceValidateTags:InvalidHedTagInput');
            testCase.verifyError(@() testCase.hed.validateTags( ...
                {'Red, Blue/Apple', 'Green, Blech'}, ...
                'checkWarnings', false), ...
                'HedToolsServiceValidateTags:InvalidHedTagInput');
        end

    end
    % % Todo: test with and without schema
    % Todo: test with definitions

end