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
            mkdir(fullfile(testCase.TestRootPath, 'subDir1', 'subDir3'));
        end
    end

    methods (TestClassTeardown)
        function deleteTestDirectory(testCase)
            % Clean up the test directory
            rmdir(testCase.TestRootPath, 's');
        end
    end

    methods (Test)

        function testNoRestrictions(testCase)
            % Pass through all of the files
            namePrefix = '';
            nameSuffix = '';
            extensions = {};
            excludeDirs = {};
            selectedFiles = getFileList(testCase.TestRootPath, ...
                      namePrefix, nameSuffix, extensions, excludeDirs);
            testCase.verifyEqual(length(selectedFiles), 12);
        end

        function testNameRestrictions(testCase)
            % Pass through all of the files
            namePrefix = 'file';
            nameSuffix = '';
            extensions = {};
            excludeDirs = {};
            selectedFiles = getFileList(testCase.TestRootPath, ...
                namePrefix, nameSuffix, extensions, excludeDirs);
            testCase.verifyEqual(length(selectedFiles), 3);
            nameSuffix = 'file2';
            selectedFiles = getFileList(testCase.TestRootPath, ...
                namePrefix, nameSuffix, extensions, excludeDirs);
            testCase.verifyEqual(length(selectedFiles), 0);
            namePrefix = 'da';
            nameSuffix = 'ta';
            selectedFiles = getFileList(testCase.TestRootPath, ...
                namePrefix, nameSuffix, extensions, excludeDirs);
            testCase.verifyEqual(length(selectedFiles), 3);
        end

        function testExtRestrictions(testCase)
            % Pass through all of the files
            namePrefix = '';
            nameSuffix = '';
            extensions = {'.m'};
            excludeDirs = {};
            selectedFiles = getFileList(testCase.TestRootPath, ...
                namePrefix, nameSuffix, extensions, excludeDirs);
            testCase.verifyEqual(length(selectedFiles), 6);
            extensions = {'.m', '.mat', '.txt'};
            selectedFiles = getFileList(testCase.TestRootPath, ...
                namePrefix, nameSuffix, extensions, excludeDirs);
            testCase.verifyEqual(length(selectedFiles), 12);
            extensions = {'.pdf'};
            selectedFiles = getFileList(testCase.TestRootPath, ...
                namePrefix, nameSuffix, extensions, excludeDirs);
            testCase.verifyEqual(length(selectedFiles), 0);
        end

       function testDirRestrictions(testCase)
            % Pass through all of the files
            namePrefix = '';
            nameSuffix = '';
            extensions = {};
            excludeDirs = {'subDir1'; 'subDir2'};
            selectedFiles = getFileList(testCase.TestRootPath, ...
                namePrefix, nameSuffix, extensions, excludeDirs);
            testCase.verifyEqual(length(selectedFiles), 4);
            excludeDirs = {'subDir1/subDir3'; 'subDir2'};
            selectedFiles = getFileList(testCase.TestRootPath, ...
                namePrefix, nameSuffix, extensions, excludeDirs);
            testCase.verifyEqual(length(selectedFiles), 8);
       end

        function testInvalidInputHandling(testCase)
            % Test the function's response to invalid inputs
           f = @() getFileList();
           testCase.verifyError(f, 'MATLAB:minrhs')

           f = @() getFileList('', 1, 2, 3, 4);
           testCase.verifyError(f, 'getFileList:RootDirIsEmpty')

           f = @() getFileList(testCase.TestRootPath, 1, 2, 3, 4);
           testCase.verifyError(f, 'MATLAB:cellfun:NotACell')

           f = @() filterFiles(1, 2, 3, 4, 5, 6);
           testCase.verifyError(f, 'MATLAB:TooManyInputs')

        end

    end
end