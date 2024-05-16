function issue_string = validate_hedtags(hed_string, schema, ...
                                        check_warnings, hed_defs)
% Validate a string containing HED tags.
% 
% Parameters:
%    hed_string - A MATLAB string or character array.
%    schema - A HED schema object or HED schema version
%    check_warnings - Boolean indicating checking for warnings
%    hed_defs - A structure with HED definitions.
%
% Returns:
%     issue_string - A string with the validation issues suitable for
%                   printing (has newlines).
% ToDo:  Make hedDefinitions optional.
%
    hmod = py.importlib.import_module('hed');
    vmod = py.importlib.import_module('hed.validator');
    schema_obj = get_schema_obj(schema);

    hed_string_obj = hmod.HedString(hed_string, schema_obj);
    ehandler = py.hed.errors.error_reporter.ErrorHandler(...
                    check_for_warnings=check_warnings);
    validator = vmod.HedValidator(schema_obj);
    issues = validator.validate(hed_string_obj, false, ...
        error_handler=ehandler);
    if isempty(issues)
        issue_string = '';
    else
        issue_string = string(py.hed.get_printable_issue_string(issues));
    end
