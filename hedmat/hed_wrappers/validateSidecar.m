function [issueString, hasErrors] = validateSidecar(sidecarObj, ...
    hedSchema, checkForWarnings)
% Validate a sidecar containing HED tags.
% 
% Parameters:
%    sidecarObj - Sidecar object
%    hedSchema - A HED schema object or HedVersion
%    checkForWarnings - Boolean indicating checking for warnings
%
% Returns:
%     issueString - A string with the validation issues suitable for
%                   printing (has newlines).
%     issues - Actual py.list of issues to filter for errors.
%
    % hedModule = py.importlib.import_module('hed');
    errorMod = py.importlib.import_module('hed.errors.error_reporter');
    hedSchema = getHedSchema(hedSchema);
    errorHandler = errorMod.ErrorHandler(...
                    check_for_warnings=checkForWarnings);
    issues = sidecarObj.validate(hedSchema, error_handler=errorHandler);
    hasErrors = errorMod.check_for_any_errors(issues);
    if isempty(issues)
        issueString = '';
    else
        issueString = string(py.hed.get_printable_issue_string(issues));
    end
