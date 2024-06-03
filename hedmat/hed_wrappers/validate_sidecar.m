function [issue_string, has_errors] = validate_sidecar(sidecar_obj, ...
    schema, check_warnings)
% Validate a sidecar containing HED tags.
% 
% Parameters:
%    sidecar_obj - Sidecar object
%    schema - A HED schema object or HED version.
%    check_warnings - Boolean indicating checking for warnings
%
% Returns:
%     issue_string - A string with the validation issues suitable for
%                   printing (has newlines).
%     has_errors - Flag indicating actual errors rather than just warnings.
%
    emod = py.importlib.import_module('hed.errors.error_reporter');
    schema = get_schema_obj(schema);
    ehandler = emod.ErrorHandler(check_for_warnings=check_warnings);
    issues = sidecar_obj.validate(schema, error_handler=ehandler);
    has_errors = emod.check_for_any_errors(issues);
    if isempty(issues)
        issue_string = '';
    else
        issue_string = string(py.hed.get_printable_issue_string(issues));
    end
