classdef HedToolsPython < HedTools
    % Creates a concrete class that uses direct calls to Python for its
    % implementation.

    properties
        HedVersion
        HedSchema
        hmod
    end

    methods
        function obj = HedToolsPython(version)
            % Construct a HedToolsPython object for calling HedTools.
            %
            % Parameters:
            %  version - string or char array or cellstr
            %               representing a valid HED version.
            %
            obj.hmod = py.importlib.import_module('hed');
            obj.resetHedVersion(version)
        end

        function [] = resetHedVersion(obj, version)
            obj.HedVersion = version;
            obj.setHedSchema(version);
        end

        function [] = setHedSchema(obj, schema)
            % Set a HedSchema or HedSchemaGroup object based on hedVersion
            %
            % Parameters:
            %    schema - a single string or a cell array of strings representing
            %           the HED schema version or a schema object.
            %
            % Returns:
            %     schema_obj - A hedSchema object
            %

            if ischar(schema)
                obj.HedSchema = obj.hmod.load_schema_version(schema);
            elseif iscell(schema)
                obj.HedSchema = obj.hmod.load_schema_version(py.list(schema));
            elseif py.isinstance(schema, obj.hmod.HedSchema) || ...
                    py.isinstance(schema, obj.hmod.HedSchemaGroup)
                obj.HedSchema = schema;
            else
                obj.HedSchema = py.None;
            end
        end


        function issueString = validateHedTags(obj, hedTags, checkWarnings)
            % Validate a string containing HED tags.
            %
            % Parameters:
            %    hedTags - A MATLAB string or character array.
            %    checkWarnings - Boolean indicating checking for warnings
            %
            % Returns:
            %     issueString - A string with the validation issues suitable for
            %                   printing (has newlines).
            % ToDo:  Make hedDefinitions optional.
            %
           
            % vmod = py.importlib.import_module('hed.validator');
            
            if ~ischar(hedTags) && ~isstring(hedTags)
                throw(MException(...
                    'HedToolsPythonValidateHedTags:InvalidHedTagInput', ...
                    'Must provide a string or char array as input'))
            end
               
            hedStringObj = py.hed.HedString(hedTags, obj.HedSchema);
            ehandler = py.hed.errors.error_reporter.ErrorHandler(...
                check_for_warnings=checkWarnings);
            validator = ...
                py.hed.validator.hed_validator.HedValidator(obj.HedSchema);
            issues = ...
                validator.validate(hedStringObj, false, ...
                error_handler=ehandler);
            if isempty(issues)
                issueString = '';
            else
                issueString = ...
                    string(py.hed.get_printable_issue_string(issues));
            end
        end

        function issueString = validateSidecar(obj, sidecar, checkWarnings)
            % Validate a sidecar containing HED tags.
            %
            % Parameters:
            %    sidecar - string, struct or char of sidecar
            %    checkWarnings - boolean indicating checking for warnings
            %
            % Returns:
            %     issueString - A string with the validation issues suitable for
            %                   printing (has newlines).
           
            ehandler = py.hed.errors.error_reporter.ErrorHandler(...
                check_for_warnings=checkWarnings);
            sidecarObj = py.hed.strs_to_sidecar(...
                HedTools.formatSidecar(sidecar));
            issues = sidecarObj.validate(obj.HedSchema, error_handler=ehandler);
            if isempty(issues)
                issueString = '';
            else
                issueString = string(py.hed.get_printable_issue_string(issues));
            end
        end
    end
end