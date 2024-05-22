classdef HedToolsPython < HedTools
    % Creates a concrete class that uses direct calls to Python for its
    % implementation.

    properties
        HedVersion
        HedSchema
    end

    methods
        function obj = HedToolsPython(version)
            % Construct a HedToolsPython object for calling HedTools.
            %
            % Parameters:
            %  version - string or char array or cellstr
            %               representing a valid HED version.
            %
     
            obj.resetHedVersion(version)
        end

        function annotations = getHedAnnotations(obj, ...
                events, sidecar, removeTypes, includeContext, replaceDefs)
            % Return a Python list of HedString objects -- used as input for search.
            %
            % Parameters:
            %      events - a TabularInput obj
            %      sidecar - a hedSchema or hedVersion
            %      remove_types - a cell array of types to remove.
            %      include_context - boolean true->expand context (usually true).
            %      replace_defs - boolean true->replace def with definition (usually true).
            %
            % Returns:
            %    hed_string_objs (py.list of HedString objects)
            %
            % Note this is used as the basis for HED queries or for assembled HED.
            % To manipulate directly in MATLAB -- convert to a cell array of char
            % using string(cell(hedObjs))

            hmod = py.importlib.import_module('hed');
            eventManager = hmod.EventManager(events, obj.schema);
            tagManager = hmod.HedTagManager(eventManager, ...
                py.list(removeTypes));
            annotations = ...
                tagManager.get_hed_objs(includeContext, replaceDefs);
        end

        function [] = resetHedVersion(obj, version)
            % Change the HED Version used.
            %
            % Parameters:
            %    version - cell array or char array or string with HED
            %              version specification.
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
                obj.HedSchema = py.hed.load_schema_version(schema);
            elseif iscell(schema)
                obj.HedSchema = py.hed.load_schema_version(py.list(schema));
            elseif py.isinstance(schema, obj.hmod.HedSchema) || ...
                    py.isinstance(schema, obj.hmod.HedSchemaGroup)
                obj.HedSchema = schema;
            else
                obj.HedSchema = py.None;
            end
        end

        function issueString = validateEvents(obj, events, sidecar, checkWarnings)
            % Validate HED in events or other tabular-type input.
            %
            % Parameters:
            %    events - char array, string, or struct.
            %    sidecar - char, string or struct representing sidecar
            %    checkWarnings - Boolean indicating checking for warnings
            %
            % Returns:
            %     issueString - A string with the validation issues suitable for
            %                   printing (has newlines).
            
            issueString = '';
            sidecarObj = py.None;
            ehandler = py.hed.errors.error_reporter.ErrorHandler(...
                check_for_warnings=checkWarnings);
            if ~isempty(sidecar) && ~isequal(sidecar, py.None)
                sidecar = HedTools.formatSidecar(sidecar);
                sidecarObj = py.hed.tools.analysis.annotation_util.strs_to_sidecar(sidecar);
                issues = sidecarObj.validate(obj.HedSchema, error_handler=ehandler);
                issueString = string(py.hed.get_printable_issue_string(issues));
                if py.hed.errors.error_reporter.check_for_any_errors(issues)
                     return;
                end     
            end
            events = py.hed.tools.analysis.annotation_util.str_to_tabular(events, sidecarObj);
            issues = events.validate(obj.HedSchema, error_handler=ehandler);
            issueString = issueString + ...
                string(py.hed.get_printable_issue_string(issues));
   
        end

        function issueString = validateTags(obj, hedTags, checkWarnings)
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
            %    sidecar - a formatted sidecar
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

    methods (Static)

        function hedStringObjs = getHedStringObjs(tabular, schema, removeTypes, ...
                includeContext, replaceDefs)
            % Return a Python list of HedString objects -- used as input for search.
            %
            % Parameters:
            %      tabular - a TabularInput obj
            %      schema - a hedSchema or hedVersion
            %      removeTypes - a cell array of types to remove.
            %      includeContext - boolean true->expand context (usually true).
            %      replaceDefs - boolean true->replace def with definition (usually true).
            %
            % Returns:
            %    hedStringObjs (py.list of HedString objects)
            %
            % Note this is used as the basis for HED queries or for assembled HED.
            % To manipulate directly in MATLAB -- convert to a cell array of char
            % using string(cell(hedObjs))

            hmod = py.importlib.import_module('hed');
            eventManager = hmod.EventManager(events, schema);
            tagManager = hmod.HedTagManager(eventManager, ...
                py.list(removeTypes));
            hedStringObjs = ...
                tagManager.get_hed_objs(includeContext, replaceDefs);
        end

        function sidecarObj = getSidecarObj(sidecar)
            % Returns a HEDTools Sidecar object extracted from input.
            %
            % Parameters:
            %    sidecar - Sidecar object, string, struct or char
            %
            % Returns:
            %     sidecar_obj - a HEDTools Sidecar object.
            %
            hmod = py.importlib.import_module('hed');
            umod = py.importlib.import_module('hed.tools.analysis.annotation_util');
            if py.isinstance(sidecar, hmod.Sidecar)
                sidecarObj = sidecar;
            elseif ischar(sidecar)
                sidecarObj = umod.strs_to_sidecar(sidecar);
            elseif isstring(sidecar)
                sidecarObj = umod.strs_to_sidecar(char(sidecar));
            elseif isstruct(sidecar)
                sidecarObj = umod.strs_to_sidecar(jsonencode(sidecar));
            else
                throw(MException('HedToolsPythonGetSidecarObj:BadInputFormat', ...
                    'Sidecar must be char, string, struct, or Sidecar'));
            end
        end

        function tabularObj = getTabularObj(events, sidecar)
            % Returns a HED TabularInput object representing events or other columnar item.
            %
            % Parameters:
            %    events - string, struct, or TabularInput for tabular data.
            %    sidecar - Sidecar object, string, or struct or py.None
            %
            % Returns:
            %     tabularObj - HEDTools TabularInput object representing tabular data.
            %
            hmod = py.importlib.import_module('hed');
            umod = py.importlib.import_module('hed.tools.analysis.annotation_util');
            if py.isinstance(events, hmod.TabularInput)
                tabularObj = events;
                return;
            end
            if isempty(sidecar) || (isa(sidecar, 'py.NoneType') && sidecar == py.None)
                sidecarObj = py.None;
            else
                sidecarObj = HedToolsPython.getSidecarObj(sidecar);
            end
            if isstruct(events)
                events = struct2string(events);
                tabularObj = umod.str_to_tabular(events, sidecarObj);
            elseif ischar(events) || isstring(events)
                tabularObj = umod.str_to_tabular(events, sidecarObj);
            else
                throw(MException('HedToolsPytonGetTabularInput:Invalid input'))
            end
        end

    end
end