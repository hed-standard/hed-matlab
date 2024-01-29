classdef TestFilterDirectories < matlab.unittest.TestCase

    properties
        TestPath
        TestSubFullPaths
    end

    methods (TestClassSetup)
        function createTestEnvironment(testCase)
            % Create the names of the test directories
            testCase.TestPath = mfilename('fullpath');
            subPaths = {'sub1'; ['sub2' filesep 'sub1']; ...
                ['exclude1' filesep 'exclude2']; 'sub3'; 'exclude1'; ...
                'exclude2'; ['sub3' filesep 'sub1']};
            stringToAppend = [testCase.TestPath filesep];
            testCase.TestSubFullPaths = cellfun(@(x) [stringToAppend x], ...
                subPaths, 'UniformOutput', false);
        end
    end

    methods (TestClassTeardown)
        function deleteTestDirectory(testCase) %#ok<MANU>
            % Clean up the test directory
        end
    end

    methods (Test)
        function testBasicFunctionality(testCase)
            % Test basic separate file functionality
            newList = filterDirectories( ...
                testCase.TestSubFullPaths, testCase.TestSubFullPaths([3, 1]));
            testCase.verifyEqual(length(newList), 5)
            
        end

        function testNoMatchingDirectories(testCase)
            % Test when no files should match
            excludeDirs = cellfun(@(x) [testCase.TestPath filesep x], ...
                {'apple', 'banana'}, 'UniformOutput', false);
            newList = filterDirectories(testCase.TestSubFullPaths, excludeDirs);
            testCase.verifyEqual(length(testCase.TestSubFullPaths), length(newList));
            testCase.verifyEqual(length(excludeDirs), 2);
        end

       function testFilterEmptyList(testCase)
            % Test various directories are empty
            
            newList = filterDirectories(...
                {}, testCase.TestSubFullPaths([3, 1]));
            testCase.verifyEqual(length(newList), 0);
            newList = filterDirectories(testCase.TestSubFullPaths, {});
            testCase.verifyEqual(length(newList), length(testCase.TestSubFullPaths));
       end

        function testInvalidInputHandling(testCase)
            % Test the function's response to invalid inputs
           f = @() filterDirectories();
           testCase.verifyError(f, 'MATLAB:minrhs')

           f = @() filterDirectories(2, 3);
           testCase.verifyError(f, 'MATLAB:cellRefFromNonCell')
        end

        function testEmptyArguments(testCase)
            % Test function behavior with empty arguments
           f = @() filterDirectories('');
           testCase.verifyError(f, 'MATLAB:cellRefFromNonCell')
        end
    end
end