function [issueString, hasErrors] = validateEvents(events, hedSchema, ...
                                        checkForWarnings)
% Validate a sidecar containing HED tags.
% 
% Parameters:
%    events - HEDTools TabularInput object
%    hedSchema - A HED schema object or HedVersion
%    checkForWarnings - Boolean indicating checking for warnings
%
% Returns:
%     issueString - A string with the validation issues suitable for
%                   printing (has newlines).
%     hasErrors - boolean true if there were errors not just warnings
%
    hasErrors = false;
    issueString = "";
    errorMod = py.importlib.import_module('hed.errors.error_reporter');
    hedSchema = getHedSchema(hedSchema); 
    sidecar = events.get_sidecar();
    if ~isempty(sidecar) && ~isequal(sidecar, py.None)
        [issueString, hasErrors] = ...
            validateSidecar(sidecar, hedSchema, checkForWarnings);
    end
    if ~hasErrors
        errorHandler = errorMod.ErrorHandler(check_for_warnings=checkForWarnings);
        issues = events.validate(hedSchema, error_handler=errorHandler);
        hasErrors = errorMod.check_for_any_errors(issues);
        issueString = issueString + string(py.hed.get_printable_issue_string(issues));
    end
end
   

   