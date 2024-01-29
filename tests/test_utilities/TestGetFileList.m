classdef TestGetFileList < matlab.unittest.TestCase

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
            for k = 1:length(files)
                fclose(fopen(fullfile(testCase.TestRootPath, files{k}), 'w'));
            end

            % Create subdirectories and files within them
            for k = 1:length(subDirs)
                subDirPath = fullfile(testCase.TestRootPath, subDirs{k});
                mkdir(subDirPath);
                % Create files in the subdirectory
                for j = 1:length(files)
                    fclose(fopen(fullfile(subDirPath, files{j}), 'w'));
                end
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
            namePrefix = '';
            nameSuffix = '';
            extensions = {};
            excludeDirs = {};
            selectedFiles = getFileList(testCase.TestRootPath, ...
                      namePrefix, nameSuffix, extensions, excludeDirs);
            disp(length(selectedFiles))
            Test basic file finding functionality
    
        end
   
        % function testCheckDirExclusions(testCase)
        %     %
        %     nextDir 

        function testNoMatchingFiles(testCase)
            % Test when no files should match
        end

        function testExcludeDirectories(testCase)
            % Test excluding certain directories
        end

        function testInvalidInputHandling(testCase)
            % Test the function's response to invalid inputs
        end

        function testEmptyArguments(testCase)
            % Test function behavior with empty arguments
        end
    end
end