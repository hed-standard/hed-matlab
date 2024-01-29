% Create a test suite for all tests in a directory
suite = testsuite('.', 'IncludingSubfolders', true);

% Create a test runner
runner = matlab.unittest.TestRunner.withTextOutput;

% Optionally, add detailed output or other plugins
% runner.addPlugin(matlab.unittest.plugins.TestReportPlugin.producingPDF('ReportName'));

% Run the test suite
results = runner.run(suite);

% Display the results
disp(results);
