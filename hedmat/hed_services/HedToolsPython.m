classdef HedToolsPython < HEDToolsBase
    % Creates a concrete class that uses direct calls to Python for its
    % implementation.

    properties
        HedVersion
        hmod
    end

    methods
        function obj = HedToolsPython()
            % Construct a HedToolsPython object for calling HedTools.
            %
            % Parameters:
            %  host - string or char array with the host name of service
            %
            obj.hmod = py.importlib.import_module('hed');
        end

        function [] = setHedVersion(obj, version)
            obj.HedVersion = version;
            obj.HedSchema = obj.getHedSchema(version);
        end

        function schema = getHedSchema(obj, schema)
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


        function issues = validate_hedtags(obj, hedtags, ...
                schema_version, check_warnings)
            request = getRequestTemplate();
            request.service = 'strings_validate';
            request.schema_version = schema_version;
            if ~iscell(hedtags)
                hedtags = {hedtags};
            end
            request.string_list = hedtags;
            request.check_for_warnings = check_warnings;
            response = webwrite(obj.ServicesUrl, request, obj.WebOptions);
            response = jsondecode(response);
            error_msg = HedService.getResponseError(response);
            if error_msg
                throw(MException('HedService:UnableToPerformOperation', ...
                    error_msg));
            end
            if strcmpi(response.results.msg_category, 'warning')
                issues = response.results.data;
            else
                issues = '';
            end

        end
    end




    end

end

