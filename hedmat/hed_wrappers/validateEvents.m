function issueString = validateEvents(events, hedSchema, sidecar, checkForWarnings)
% Validate a sidecar containing HED tags.
% 
% Parameters:
%    events - string path to events file or events struct or events table
%    hedSchema - A HED schema object or HedVersion
%    sidecar - JSON file, struct, or a Sidecar object
%    checkForWarnings - Boolean indicating checking for warnings
%
% Returns:
%     issueString - A string with the validation issues suitable for
%                   printing (has newlines).
%
    hedModule = py.importlib.import_module('hed');
    hedSchema = getHedSchema(hedSchema);
    sidecar = getSidecar(sidecar);
    errorHandler = py.hed.errors.error_reporter.ErrorHandler(...
                    check_for_warnings=checkForWarnings);
    issues = sidecarObj.validate(hedSchema, error_handler=errorHandler);
    if isempty(issues)
        issueString = '';
    else
        issueString = string(py.hed.get_printable_issue_string(issues));
    end
   % eventTable = struct2table(events);
   % columnNames = eventTable.Properties.VariableNames;
   % if ~ismember('onset', columnNames)
   %     eventTable.onset = (eventTable.latency - 1)./srate;
   % end
   % for k=1:length(columnNames)
   %     thisColumn = columnNames{k};
   %     if ismember(thisColumn, {'onset', 'duration', 'sample', 'latency'})
   %         continue;
   %     end
   %     % Convert other columns to string and replace missing with `n/a`.
   %     eventTable.(thisColumn) = string(eventTable.(thisColumn));
   %     eventTable.(thisColumn)(eventTable.(thisColumn) == "" | ...
   %         ismissing(eventTable.(thisColumn))) = "n/a";
   % end
   

   