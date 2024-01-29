classdef TestFilterDirectories < matlab.unittest.TestCase

    properties
        TestPath
        TestSubFullPaths
        TestSubPaths
    end

    methods (TestClassSetup)
        function createTestEnvironment(testCase)
            % Create the names of the test directories
            testCase.TestPath = mfilename('fullpath');
            testCase.TestSubPaths = {'sub1'; ['sub2' filesep 'sub1']; ...
                ['exclude1' filesep 'exclude2']; 'sub3'; 'exclude1'; ...
                'exclude2'; ['sub3' filesep 'sub1']};
            stringToAppend = [testCase.TestPath filesep];
            testCase.TestSubFullPaths = cellfun(@(x) [stringToAppend x], ...
                testCase.TestSubPaths, 'UniformOutput', false);
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
            newList = filterDirectories(testCase.TestPath, ...
                testCase.TestSubPaths, testCase.TestSubFullPaths([3, 1]));
            testCase.verifyEqual(length(newList), 5)
            
        end

        function testNoMatchingDirectories(testCase)
            % Test when no files should match
            excludeDirs = cellfun(@(x) [testCase.TestPath filesep x], ...
                {'apple', 'banana'}, 'UniformOutput', false);
            newList = filterDirectories(testCase.TestPath, ...
                testCase.TestSubPaths, excludeDirs);
            testCase.verifyEqual(length(testCase.TestSubPaths), length(newList));
            testCase.verifyEqual(length(excludeDirs), 2);
        end

       function testFilterEmptyList(testCase)
            % Test various directories are empty
            
            newList = filterDirectories(testCase.TestPath, ...
                {}, testCase.TestSubFullPaths([3, 1]));
            testCase.verifyEqual(length(newList), 0);
            newList = filterDirectories(testCase.TestPath, ...
                testCase.TestSubPaths, {});
            testCase.verifyEqual(length(newList), length(testCase.TestSubPaths));
       end

        function testInvalidInputHandling(testCase)
            % Test the function's response to invalid inputs
           f = @() filterDirectories();
           testCase.verifyError(f, 'MATLAB:minrhs')

           f = @() filterDirectories(1, 2, 3);
           testCase.verifyError(f, 'MATLAB:cellRefFromNonCell')
        end

        function testEmptyArguments(testCase)
            % Test function behavior with empty arguments
           f = @() filterDirectories('');
           testCase.verifyError(f, 'MATLAB:minrhs')
        end
    end
end