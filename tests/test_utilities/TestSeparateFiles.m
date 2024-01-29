classdef TestSeparateFiles < matlab.unittest.TestCase

    properties
        TestRootPath
    end

    methods (TestClassSetup)
        function createTestEnvironment(testCase)
            % Create the root test directory
            testCase.TestRootPath = fullfile(tempdir, 'TestGetFileList');
            mkdir(testCase.TestRootPath);

            % Example: Create files and subdirectories for testing
            files = {'file1.m', 'test2.txt', 'script3.m', 'data.mat'};
            subDirs = {'subDir1', 'subDir2'};

            % Create files in the root directory
            for i = 1:length(files)
                fclose(fopen(fullfile(testCase.TestRootPath, files{i}), 'w'));
            end

            % Create subdirectories
            for i = 1:length(subDirs)
                subDirPath = fullfile(testCase.TestRootPath, subDirs{i});
                mkdir(subDirPath);
            end

        end
    end

    methods (TestClassTeardown)
        function deleteTestDirectory(testCase)
            % Clean up the test directory
            rmdir(testCase.TestRootPath, 's');
        end
    end

    methods (Test)
        function testBasicFunctionality(testCase)
            % Test basic separate file functionality
            [files, dirs] = separateFiles(testCase.TestRootPath);
            testCase.verifyEqual(length(files), 4)
            testCase.verifyEqual(length(dirs), 2)
        end

        function testNoMatchingFiles(testCase)
            % Test when no files should match
            emptyDir = fullfile(testCase.TestRootPath, 'subDir3');
            mkdir(emptyDir);
            [files, dirs] = separateFiles(emptyDir);
            testCase.verifyEmpty(files);
            testCase.verifyEmpty(dirs);
        end

        function testInvalidInputHandling(testCase)
            % Test the function's response to invalid inputs
           f = @() separateFiles('temp.m');
           testCase.verifyError(f, 'separateFiles:dirPathNotADirectory')

           f = @() separateFiles('./xxx/');
           testCase.verifyError(f, 'separateFiles:dirPathNotADirectory')

           f = @() separateFiles(43);
           testCase.verifyError(f, 'MATLAB:exist:firstInputString')
        end

        function testEmptyArguments(testCase)
            % Test function behavior with empty arguments
           f = @() separateFiles('');
           testCase.verifyError(f, 'separateFiles:dirPathNotADirectory')
        end
    end
end