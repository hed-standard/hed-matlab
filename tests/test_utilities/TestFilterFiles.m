classdef TestFilterFiles < matlab.unittest.TestCase

    properties
        TestFiles
    end

    methods (TestClassSetup)
        function createTestEnvironment(testCase)
            % Create the names of the test directories
            testCase.TestFiles = {['a' filesep 'taskevents.tsv']; ...
                'task.tsv'; 'task.doc'; 'events.tsv'; ...
                'events_apple_task.tsv'; 'applesevents.csv'; 'events.csv'};

        end
    end

    methods (TestClassTeardown)
        function deleteTestDirectory(testCase)
            % Clean up the test directory
        end
    end

    methods (Test)
        function testBasicFunctionality(testCase)
            % Test basic separate file functionality
            newList = filterFiles(testCase.TestFiles, 'task', 'events', {'.tsv'});
            testCase.verifyEqual(length(newList), 1)
        end

        function testNoMatchingFiles(testCase)
            % Test when no files should match
            newList = filterFiles(testCase.TestFiles, 'grinch', 'events', {'.tsv'});
            testCase.verifyEmpty(newList);
        end

       function testFilterEmptyList(testCase)
            % Test various directories are empty
            newList = filterFiles({}, '', '', {});
            testCase.verifyEmpty(newList);
        end

        function testInvalidInputHandling(testCase)
            % Test the functions response to invalid inputs
           f = @() filterFiles();
           testCase.verifyError(f, 'MATLAB:minrhs')

           f = @() filterFiles(1, 2, 3, 4);
           testCase.verifyError(f, 'MATLAB:cellfun:NotACell')

           f = @() filterFiles(1, 2, 3, 4, 5);
           testCase.verifyError(f, 'MATLAB:TooManyInputs')

        end
    end
end