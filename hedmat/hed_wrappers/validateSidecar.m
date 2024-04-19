function issueString = validateSidecar(sidecar, hedSchema, checkForWarnings)
% Validate a sidecar containing HED tags.
% 
% Parameters:
%    sidecar - JSON string or a Sidecar object
%    hedSchema - A HED schema object or HedVersion
%    checkForWarnings - Boolean indicating checking for warnings
%
% Returns:
%     issueString - A string with the validation issues suitable for
%                   printing (has newlines).
%
    hedModule = py.importlib.import_module('hed');
    if ~py.isinstance(hedSchema, hedModule.HedSchema) && ...
       ~py.isinstance(hedSchema, hedModule.HedSchemaGroup)
        hedSchema = getHedSchema(hedSchema);
    end
    if py.isinstance(sidecar, hedModule.Sidecar)
        sidecarObj = sidecar;
    end
    errorHandler = py.hed.errors.error_reporter.ErrorHandler(...
                    check_for_warnings=checkForWarnings);
    issues = sidecarObj.validate(hedSchema, error_handler=errorHandler);
    if isempty(issues)
        issueString = '';
    else
        issueString = string(py.hed.get_printable_issue_string(issues));
    end
