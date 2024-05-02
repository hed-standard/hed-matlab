%host = 'https://hedtools.org/hed';
host = 'https://hedtools.org/hed_dev';

errorMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
errorMap('demoGetServices') = demoGetServices(host);
errorMap('demoEventServices') = demoEventServices(host);
errorMap('demolEventSearchServices') = demoEventSearchServices(host);
errorMap('demoEventRemodelingServices') = demoEventRemodelingServices(host);
errorMap('demoSidecarServices') = demoSidecarServices(host);
errorMap('demoSpreadsheetServices') = demoSpreadsheetServices(host);
errorMap('demoStringServices') = demoStringServices(host);
%errorMap('demoLibraryServices') = demoLibraryServices(host);

%% Output the errors
fprintf('\n\nOverall error report:\n');
keys = errorMap.keys();
for k = 1:length(keys)
    errors = errorMap(keys{k});
    if isempty(errors)
        fprintf('\t%s: no errors\n', keys{k});
    else
        fprintf('\t%s:\n', keys{k});
        for n = 1:length(errors)
           fprintf('\t\t%s\n', keys{k}, errors{n});
        end
    end
end
