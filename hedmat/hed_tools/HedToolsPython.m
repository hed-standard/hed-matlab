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
            % Return a cell array of HED annotations of same length as events.
            %
            % Parameters:
            %    events - char, string or rectified struct.
            %    sidecar - char, string or struct representing sidecar
            %    removeTypes - a cell array of types to remove.
            %    includeContext - boolean true->expand context (usually true).
            %    replaceDefs - boolean true->replace def with definition (usually true).
            %
            % Returns:
            %     annotations - cell array with the HED annotations.
            %
            % Note: The annotations do not have a header line, while
            % events in char or string form is assumed to have a header
            % line.
            % 

            events = HedToolsPython.getTabularObj(events, sidecar);
            issueString = obj.validateEvents(events, sidecar, false);
            if ~isempty(issueString)
                throw(MException( ...
                    'HedToolsPythonGetHedAnnotations:InvalidData', ...
                    "Input errors:\n" + issueString));
            end
            hedObjs = HedToolsPython.getHedStringObjs(events, ...
                  obj.HedSchema, removeTypes, includeContext, replaceDefs);
            strs = ...
                py.hed.tools.analysis.annotation_util.to_strlist(hedObjs);
            cStrs = cell(strs);
            % Convert each string object in the cell array to a char array
            annotations = cellfun(@char, cStrs(:), 'UniformOutput', false);
        end

        function factors = getHedFactors(obj, annotations, queries)
            %% Return an array of 0's and 1's indicating query truth
            %
            %  Parameters:
            %     annotations - cell array of char or string of length n
            %     queries = cell array HED queries of length m
            %
            %  Returns:
            %     factors - n x m array of 1's and 0's.
            %

            queries, query_names, issues = ...
                obj.hed.get_query_handlers(queries);
            issueString = char(py.hed.get_printable_issue_string(issues));
            if ~isempty(issueString)
                throw(MException( ...
                    'HedToolsPythonGetHedFactors:InvalidQueries', ...
                    "Input errors:\n" + issueString));
            end
            p = py.numpy.array(magic(3))
            factors = obj.hed.query_service.search_hed_objs()

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
            obj.HedSchema = HedToolsPython.getHedSchemaObj(schema);
        end

        function issueString = validateEvents(obj, events, sidecar, checkWarnings)
            % Validate HED in events or other tabular-type input.
            %
            % Parameters:
            %    events - char array, string, struct (or tabularInput)
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
                issueString = ...
                    char(py.hed.get_printable_issue_string(issues));
                if py.hed.errors.error_reporter.check_for_any_errors(issues)
                     return;
                end     
            end
            eventsObj = HedToolsPython.getTabularObj(events, sidecarObj);
            issues = eventsObj.validate(obj.HedSchema, error_handler=ehandler);
            issueString = [issueString, ...
                char(py.hed.get_printable_issue_string(issues))];
   
        end

        function issueString = validateSidecar(obj, sidecar, checkWarnings)
            % Validate a sidecar containing HED tags.
            %
            % Parameters:
            %    sidecar - a char, string, struct, or SidecarObj
            %    checkWarnings - boolean indicating checking for warnings
            %
            % Returns:
            %     issueString - A string with the validation issues suitable for
            %                   printing (has newlines).
           
            ehandler = py.hed.errors.error_reporter.ErrorHandler(...
                check_for_warnings=checkWarnings);
            sidecarObj = HedToolsPython.getSidecarObj(sidecar);
            issues = sidecarObj.validate(obj.HedSchema, error_handler=ehandler);
            if isempty(issues)
                issueString = '';
            else
                issueString = ...
                    char(py.hed.get_printable_issue_string(issues));
            end
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
                    char(py.hed.get_printable_issue_string(issues));
            end
        end
    
    end

    methods (Static)

        function hedStringObjs = getHedStringObjs(tabular, schema, ...
                removeTypes, includeContext, replaceDefs)
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
            
            eventManager = hmod.EventManager(tabular, schema);
            tagManager = hmod.HedTagManager(eventManager, ...
                py.list(removeTypes));
            hedStringObjs = ...
                tagManager.get_hed_objs(includeContext, replaceDefs);
        end

        function hedSchemaObj = getHedSchemaObj(schema)
            % Get a HedSchema or HedSchemaGroup object based on hedVersion
            %
            % Parameters:
            %    schema - a single string or a cell array of strings representing
            %           the HED schema version or a schema object.
            %
            % Returns:
            %     hedSchemaObj - A hedSchema object
            %

            if ischar(schema)
                hedSchemaObj = py.hed.load_schema_version(schema);
            elseif iscell(schema)
                hedSchemaObj = py.hed.load_schema_version(py.list(schema));
            elseif py.isinstance(schema, obj.hmod.HedSchema) || ...
                    py.isinstance(schema, obj.hmod.HedSchemaGroup)
                hedSchemaObj = schema;
            else
                hedSchemaObj = py.None;
            end
        end
        
        function queryHandler = getHedQueryHandler(query)
            % Return a HED query handler.
            %
            % Parameters:
            %     query - a string query
            %
            % Returns;
            %     queryHandler - the query handler object. 

            mmod = py.importlib.import_module('hed.models');
            if isstring(query)
                query = char(query);
            end
            if ischar(query)
                try
                   queryHandler = mmod.QueryHandler(query);
                catch MException
                    throw (MException(...
                        'HedToolsPythonGetHedQueryHandler:InvalidQuery', ...
                        'Query: %s cannot be parsed.', query));
                end
            elseif py.isinstance(query, mmod.QueryHandler)
                queryHandler = query;
            else
                throw (MException( ...
                    'HedToolsPythonGetHedQueryHandler:InvalidQueryFormat', ...
                        'Query: %s has an invalid format.', query));
            end

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
            
            if ischar(sidecar)
                sidecarObj = umod.strs_to_sidecar(sidecar);
            elseif isstring(sidecar)
                sidecarObj = umod.strs_to_sidecar(char(sidecar));
            elseif isstruct(sidecar)
                sidecarObj = umod.strs_to_sidecar(jsonencode(sidecar));
            elseif isempty(sidecar) || ...
                    (isa(sidecar, 'py.NoneType') && sidecar == py.None)
                sidecarObj = py.None;
            elseif py.isinstance(sidecar, hmod.Sidecar)
                sidecarObj = sidecar;
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

            sidecarObj = HedToolsPython.getSidecarObj(sidecar);
            if isstruct(events)
                events = events2string(events);
                tabularObj = umod.str_to_tabular(events, sidecarObj);
            elseif ischar(events) || isstring(events)
                tabularObj = umod.str_to_tabular(events, sidecarObj);
            elseif py.isinstance(events, hmod.TabularInput)
                tabularObj = events;
            else
                throw(MException('HedToolsPytonGetTabularInput:Invalid input'))
            end
        end

        

    end
end