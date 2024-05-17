classdef HedToolsPython < HedToolsBase
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


        function issue_string = validate_hedtags(obj, hedtags,  ...
                check_warnings)
            % Validate a string containing HED tags.
            %
            % Parameters:
            %    hedtags - A MATLAB string or character array.
            %    check_warnings - Boolean indicating checking for warnings
            %
            % Returns:
            %     issue_string - A string with the validation issues suitable for
            %                   printing (has newlines).
            % ToDo:  Make hedDefinitions optional.
            %
           
            % vmod = py.importlib.import_module('hed.validator');
            
            if ~ischar(hedtags) && ~isstring(hedtags)
                throw(MException('HedToolsPython:validate_hedtags', ...
                    'Must provide a string or char array as input'))
            end
               
            hed_string_obj = py.hed.HedString(hedtags, obj.HedSchema);
            ehandler = py.hed.errors.error_reporter.ErrorHandler(...
                check_for_warnings=check_warnings);
            validator = ...
                py.hed.validator.hed_validator.HedValidator(obj.HedSchema);
            issues = ...
                validator.validate(hed_string_obj, false, ...
                error_handler=ehandler);
            if isempty(issues)
                issue_string = '';
            else
                issue_string = ...
                    string(py.hed.get_printable_issue_string(issues));
            end

        end

    end

end