function [issue_string, has_errors] = validate_events(events, schema, ...
                                        check_warnings)
% Validate HED in events or other tabular-type input.
% 
% Parameters:
%    events - HEDTools TabularInput object
%    schema - A HED schema object or HedVersion
%    check_warnings - Boolean indicating checking for warnings
%
% Returns:
%     issue_string - A string with the validation issues suitable for
%                   printing (has newlines).
%     has_errors - boolean true if there were errors not just warnings
%
    has_errors = false;
    issue_string = "";
    emod = py.importlib.import_module('hed.errors.error_reporter');
    schema = get_schema_obj(schema); 
    sidecar = events.get_sidecar();
    if ~isempty(sidecar) && ~isequal(sidecar, py.None)
        [issue_string, has_errors] = ...
            validate_sidecar(sidecar, schema, check_warnings);
    end
    if ~has_errors
        ehandler = emod.ErrorHandler(check_for_warnings=check_warnings);
        issues = events.validate(schema, error_handler=ehandler);
        has_errors = emod.check_for_any_errors(issues);
        issue_string = issue_string + ...
            string(py.hed.get_printable_issue_string(issues));
    end
end
   

   