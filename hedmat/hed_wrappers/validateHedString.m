function issueString = validateHedString(hedTags, hedSchema, ...
    checkForWarnings, hedDefinitions)
% Validate a string containing HED tags.
% 
% Parameters:
%    hedTags - A MATLAB string or character array.
%    hedSchema - A HED schema object or HedVersion
%    checkForWarnings - Boolean indicating checking for warnings
%    hedDefinitions - A structure with HED definitions.
%
% Returns:
%     issueString - A string with the validation issues suitable for
%                   printing (has newlines).
% ToDo:  Make hedDefinitions optional.
%
    hedModule = py.importlib.import_module('hed');
    valModule = py.importlib.import_module('hed.validator');
    schema = getHedSchema(hedSchema);

    hedString = hedModule.HedString(hedTags, schema);
    errorHandler = py.hed.errors.error_reporter.ErrorHandler(...
                    check_for_warnings=checkForWarnings);
    validator = valModule.HedValidator(schema);
    issues = validator.validate(hedString, false, error_handler=errorHandler);
    if isempty(issues)
        issueString = '';
    else
        issueString = string(py.hed.get_printable_issue_string(issues));
    end
