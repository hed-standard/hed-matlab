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
            testCase.hed = HedToolsPython('8.3.0');
            testCase.hmod = py.importlib.import_module('hed');
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
                'HedToolsPythonGetHedAnnotations:InvalidData');
        end

        function testSearchHed(testCase)
            % Simple tests of HED queries on valid strings
            annotations = {'Red', 'Sensory-event', 'Blue'};
            queries1 = {'Sensory-event'};
            factors1 = testCase.hed.searchHed(annotations, queries1);
            testCase.verifyEqual(length(factors1), 3);
            testCase.verifyTrue(factors1(2) == 1);

            % Test 2 queries on 3 strings.
            queries2 = {'Sensory-event', 'Red'};
            factors2 = testCase.hed.searchHed(annotations, queries2);
            testCase.verifyTrue(size(factors2, 1) == 3);
            testCase.verifyTrue(size(factors2, 2) == 2);
        end

        function testEventsValidNoSidecar(testCase)
            % Valid char sidecar should not have errors or warnings
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsChar), '', ...
                'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0, ...
                'Valid char events no sidecar should not have errors.');
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsChar), py.None, ...
                'checkWarnings', true);
            testCase.verifyGreaterThan(length(issueString), 0, ...
                'Valid char events no sidecar has warnings.');
        end

        function testEventsValidGoodSidecar(testCase)
            % Valid char events should not have errors or warnings
            sidecarChar = fileread(testCase.goodSidecarPath);
            eventsChar = fileread(testCase.goodEventsPath);
            testCase.verifyTrue(ischar(eventsChar))
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsChar), ...
                sidecarChar, 'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0);
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsChar), ...
                sidecarChar, 'checkWarnings', true);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid string events should not have errors or warnings
            eventsString = string(eventsChar);
            testCase.verifyTrue(isstring(eventsString))
            issueString = testCase.hed.validateEvents( ...
                HedTools.formatEvents(eventsString), sidecarChar, ...
                'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0');
            issueString = testCase.hed.validateEvents(...
                HedTools.formatEvents(eventsString), sidecarChar, ...
                'checkWarnings', true);
            testCase.verifyEqual(strlength(issueString), 0);
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
            testCase.verifyGreaterThan(strlength(issueString), 0');
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

        function testEventsValidStructNoOnsetNoSampling(testCase)
            % Unrectified struct events no onset.
            issueString = testCase.hed.validateEvents( ...
                testCase.eventsStructNoOnset, ...
                testCase.sidecarStructGood, 'checkWarnings', false);
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

            % Valid struct sidecar should not have errors or warnings
            sidecarStruct = jsondecode(sidecarChar);
            testCase.verifyTrue(isstruct(sidecarStruct))
            issueString = testCase.hed.validateSidecar( ...
                sidecarStruct, 'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid struct sidecar should not have errors or warnings
            issueString = testCase.hed.validateSidecar(...
                sidecarStruct, 'checkWarnings', true);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid sidecar obj should not have errors or warnings
            sidecarObj = HedToolsPython.getSidecarObj(sidecarChar);
            testCase.verifyTrue(py.isinstance(sidecarObj, ...
                testCase.hmod.models.sidecar.Sidecar)) 
            issueString = testCase.hed.validateSidecar( ...
                sidecarObj, 'checkWarnings', false);
            testCase.verifyEqual(strlength(issueString), 0);

            % Valid sidecar obj should not have errors or warnings
            issueString = testCase.hed.validateSidecar(...
                sidecarObj, 'checkWarnings', true);
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

            % Invalid struct sidecar should have errors
            sidecarStruct = jsondecode(sidecarChar);
            testCase.verifyTrue(isstruct(sidecarStruct))
            issueString = testCase.hed.validateSidecar( ...
                sidecarStruct, 'checkWarnings', false);
            testCase.verifyGreaterThan(strlength(issueString), 0);

            % Invalid struct sidecar should have errors with warning on
            issueString = testCase.hed.validateSidecar(...
                sidecarStruct, 'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);

            % Invalid sidecar obj should have errors
            sidecarObj = HedToolsPython.getSidecarObj(sidecarChar);
            testCase.verifyTrue(py.isinstance(sidecarObj, ...
                testCase.hmod.models.sidecar.Sidecar)) 
            issueString = testCase.hed.validateSidecar( ...
                sidecarObj, 'checkWarnings', false);
            testCase.verifyGreaterThan(strlength(issueString), 0);

            % Invalid sidecar obj should have errors with warning on
            issueString = testCase.hed.validateSidecar(...
                sidecarObj, 'checkWarnings', true);
            testCase.verifyGreaterThan(strlength(issueString), 0);
        end

        function testTagsValid(testCase)
            % Test valid check warnings has warnings
            issues = testCase.hed.validateTags('Red, Blue/Apple', ...
                'checkWarnings', true);
            testCase.verifyGreaterThan(length(issues), 0);

            % Test valid no check warnings has warnings
            issues = testCase.hed.validateTags('Red, Blue/Apple', ...
                'checkWarnings', false);
            testCase.verifyEqual(length(issues), 0);

            % Test with extension and no check warnings
            issues = testCase.hed.validateTags('Red, Blue/Apple');
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
                'HedToolsPythonValidateTags:InvalidHedTagInput');
            testCase.verifyError(@() testCase.hed.validateTags( ...
                {'Red, Blue/Apple', 'Green, Blech'}, ...
                'checkWarnings', false), ...
                'HedToolsPythonValidateTags:InvalidHedTagInput');
        end

        function testGetHedQueryHandler(testCase)
             query1 = 'Sensory-event';
             qHandler = HedToolsPython.getHedQueryHandler(query1);
             testCase.verifyTrue(py.isinstance(qHandler, ...
                 testCase.hmod.models.query_handler.QueryHandler));
        end

        function testGetHedStringObjs(testCase)
            % Valid char events should not have errors or warnings
            sidecarChar = fileread(testCase.goodSidecarPath);
            eventsChar = fileread(testCase.goodEventsPath);
            hedTabular = ...
                HedToolsPython.getTabularObj(eventsChar, sidecarChar);

            hedSchemaObj = HedToolsPython.getHedSchemaObj('8.2.0');

            % no types, no context, no replace
            removeTypesOn = false;
            includeContext = false;
            replaceDefs = false;
            hedObjs = HedToolsPython.getHedStringObjs(hedTabular, ...
                hedSchemaObj, removeTypesOn, includeContext, replaceDefs);
            hedList = ...
                testCase.hmod.tools.analysis.annotation_util.to_strlist(hedObjs);
            hedStrings = string(hedList);
            testCase.verifyEqual(length(hedStrings), 199);
            testCase.verifyTrue(strlength(hedStrings{195}) == 0);
            data1_str = strjoin(hedStrings, '\n');
            testCase.verifyEqual(strlength(data1_str), 14678);

            % With context, no remove, no replace
            removeTypesOn = false;
            includeContext = true;
            replaceDefs = false;
            hedObjs = HedToolsPython.getHedStringObjs(hedTabular, ...
                hedSchemaObj, removeTypesOn, includeContext, replaceDefs);
            hedList = ...
                testCase.hmod.tools.analysis.annotation_util.to_strlist(hedObjs);
            hedStrings = string(hedList);
            testCase.verifyEqual(length(hedStrings), 199);
            testCase.verifyGreaterThan(strlength(hedStrings{195}), 0);
            data2_str = strjoin(hedStrings, '\n');
            testCase.verifyGreaterThan(strlength(data2_str), ...
                strlength(data1_str));


            % With context, remove, no replace
            removeTypesOn = true;
            replaceDefs = false;
            includeContext = true;
            hedObjs = HedToolsPython.getHedStringObjs(hedTabular, ...
                hedSchemaObj, removeTypesOn, includeContext, replaceDefs);
            hedList = ...
                testCase.hmod.tools.analysis.annotation_util.to_strlist(hedObjs);
            hedStrings = string(hedList);
            testCase.verifyEqual(length(hedStrings), 199);
            testCase.verifyGreaterThan(strlength(hedStrings{195}), 0);
            data3_str = strjoin(hedStrings, '\n');
            testCase.verifyGreaterThan(strlength(data2_str), ...
                strlength(data3_str));

            % With context, remove, replace
            removeTypesOn = true;
            replaceDefs = true;
            includeContext = true;
            hedObjs = HedToolsPython.getHedStringObjs(hedTabular, ...
                hedSchemaObj, removeTypesOn, includeContext, replaceDefs);
            hedList = ...
                testCase.hmod.tools.analysis.annotation_util.to_strlist(hedObjs);
            hedStrings = string(hedList);
            testCase.verifyEqual(length(hedStrings), 199);
            testCase.verifyGreaterThan(strlength(hedStrings{195}), 0);
            data4_str = strjoin(hedStrings, '\n');
            testCase.verifyGreaterThan(strlength(data4_str), ...
                strlength(data3_str));

        end

        function testGetHedSchemaObjs(testCase)
            % Valid char events should not have errors or warnings
            schema = HedToolsPython.getHedSchemaObj('8.2.0');
            testCase.verifyTrue(py.isinstance(schema, ...
                testCase.hmod.schema.hed_schema.HedSchema));
            version = char(schema.version);
            testCase.verifyEqual(version, '8.2.0');
        end

        function testGetHedSchemaObjsMultiple(testCase)
            % Test complex version with prefix and partnered library
            version = {'ts:8.2.0', 'score_1.1.0'};
            schema = HedToolsPython.getHedSchemaObj(version);
            assertTrue(testCase, py.isinstance(schema, ...
                 testCase.hmod.schema.hed_schema_group.HedSchemaGroup));
            versions = cell(schema.get_schema_versions());
            testCase.verifyEqual(char(versions{1}), 'ts:8.2.0');
            testCase.verifyEqual(char(versions{2}), 'score_1.1.0');
        end

        function testGetHedSchemaObjsNone(testCase)
            % Test for error when no schema
            testCase.verifyError(@() HedToolsPython.getHedSchemaObj(''), ...
                'MATLAB:Python:PyException');
        end

        function testGetSidecarObjSidecarIn(testCase)
            % Test with incoming sidecar
            sidecar = testCase.hmod.models.sidecar.Sidecar(testCase.goodSidecarPath);
            testCase.assertTrue(py.isinstance(sidecar, ...
                testCase.hmod.models.sidecar.Sidecar));
            sidecarObj = HedToolsPython.getSidecarObj(sidecar);
            testCase.assertTrue(py.isinstance(sidecarObj, ...
                testCase.hmod.models.sidecar.Sidecar));
        end

        function testGetSidecarObjCharIn(testCase)
            % Test with incoming sidecar string
            jsonChar = fileread(testCase.goodSidecarPath);
            testCase.verifyTrue(ischar(jsonChar));
            sidecarObj = HedToolsPython.getSidecarObj(jsonChar);
            testCase.verifyTrue(py.isinstance(sidecarObj, ...
                testCase.hmod.models.sidecar.Sidecar));
        end

        function testGetSidecarObjStringIn(testCase)
            % Test with incoming sidecar string
            jsonString = string(fileread(testCase.goodSidecarPath));
            testCase.verifyTrue(isstring(jsonString));
            sidecarObj = testCase.hed.getSidecarObj(jsonString);
            testCase.verifyTrue(py.isinstance(sidecarObj, ...
                testCase.hmod.models.sidecar.Sidecar));
        end

        function testGetSidecarObjStructIn(testCase)
            % Test with incoming sidecar struct
            jsonStruct = jsondecode(fileread(testCase.goodSidecarPath));
            testCase.verifyTrue(isstruct(jsonStruct));
            sidecarObj = HedToolsPython.getSidecarObj(jsonStruct);
            testCase.assertTrue(py.isinstance(sidecarObj, ...
                testCase.hmod.models.sidecar.Sidecar));
        end

        function testGetSidecarObjEmptyInputs(testCase)
            % Test for error bad inputs
            sidecar = HedToolsPython.getSidecarObj([]);
            testCase.verifyEqual(sidecar, py.None);
        end

        function testGetTabularInputSimple(testCase)
            % Test tabular input with onset column and sidecar
            events = fileread(testCase.goodEventsPath);
            sidecar = fileread(testCase.goodSidecarPath);
            tabularObj = HedToolsPython.getTabularObj(events, sidecar);
            testCase.assertTrue(py.isinstance(tabularObj, ...
                testCase.hmod.models.tabular_input.TabularInput));
        end

        function testGetTabularInputNoSidecar(testCase)
            % Test tabular input with no sidecar
            events = fileread(testCase.goodEventsPath);
            sidecar = py.None;
            tabularObj = HedToolsPython.getTabularObj(events, sidecar);
            testCase.assertTrue(py.isinstance(tabularObj, ...
                testCase.hmod.models.tabular_input.TabularInput));
        end

        function testGetTabularSummary(testCase)
            % Test tabular summary with or without column specifications
            valueColumns = {'trial', 'rep_lag', 'stim_file'};
            skipColumns = {'onset', 'duration', 'sample'};
            tabularSum = HedToolsPython.getTabularSummary(...
                valueColumns, skipColumns);
            testCase.assertTrue(py.isinstance(tabularSum, ...
                testCase.hmod.tools.analysis.tabular_summary.TabularSummary));
            tabularSum1 =  HedToolsPython.getTabularSummary({}, {});
           testCase.assertTrue(py.isinstance(tabularSum1, ...
                testCase.hmod.tools.analysis.tabular_summary.TabularSummary));
        end

        function testGetTabularSummaryInvalid(testCase)
            % Test tabular input with no sidecar
            valueColumns = {'onset', 'rep_lag', 'stim_file'};
            skipColumns = {'onset', 'duration', 'sample'};
            testCase.verifyError(@() HedToolsPython.getTabularSummary(...
                valueColumns, skipColumns), ...
                'HedToolsPythonGetTabularSummary:ColumnNameOverlap');
        end

        function testGetHedFromAnnotations(testCase)
              % Normal array
              an1 = {'Sensory-event', 'Red'};
              objs1 = testCase.hed.getHedFromAnnotations(an1, ...
                  testCase.hed.HedSchema);
              testCase.assertEqual(double(py.len(objs1)), double(length(an1)));
              objs1Cell = cell(objs1);
              testCase.assertNotEqual(objs1Cell{2}, py.None);

              % Includes empty string
              an2 =  {'Sensory-event', '', 'Red'};
              objs2 = testCase.hed.getHedFromAnnotations(an2, ...
                  testCase.hed.HedSchema);
              testCase.assertEqual(double(py.len(objs2)), double(length(an2)));
              objs2Cell = cell(objs2);
              testCase.assertEqual(objs2Cell{2}, py.None);

        end
    end
end