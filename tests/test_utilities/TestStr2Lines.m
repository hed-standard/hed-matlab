classdef TestStr2Lines < matlab.unittest.TestCase

    properties
        umod
        hmod
        json_path
        events_path
    end

    methods (TestClassSetup)
        function importPythonModules(testCase)
 
        end
    end

    methods (Test)

        function testChars(testCase)
            chars1 = 'abc\n\ncde';
            result1 = str2lines(chars1);
            testCase.assertEqual(length(result1), 3)
            chars2 = '';
            result2 = str2lines(chars2);
            testCase.assertEmpty(result2);
            chars3 = '\n';
            result3 = str2lines(chars3);
            testCase.assertEqual(length(result3), 1)
            testCase.assertEmpty(result3{1});
        end

        function testStrings(testCase)
            strings1 = "abc\n\ncde";
            result1 = str2lines(strings1);
            testCase.assertEqual(length(result1), 3)
            strings2 = "";
            result2 = str2lines(strings2);
            testCase.assertEmpty(result2);
            strings3 = "\n";
            result3 = str2lines(strings3);
            testCase.assertEqual(length(result3), 1)
            testCase.assertEmpty(result3{1});

        end
    end
end