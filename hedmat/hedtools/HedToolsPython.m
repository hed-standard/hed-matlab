classdef HedToolsPython < HedTools
    % Concrete class using direct calls to Python for HedTools interface.

    properties
        hmod
        amod
        vmod
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
            obj.hmod = py.importlib.import_module('hed');
            obj.amod = py.importlib.import_module('hed.tools.analysis');
            obj.vmod = py.importlib.import_module('hed.validator');
            obj.resetHedVersion(version)
        end

        function sidecar = generateSidecar(obj, eventsIn, valueColumns, ...
                skipColumns)
            % Return a sidecar string based on an events data.py.hed
            %
            % Parameters:
            %    eventsIn - char, string or rectified struct.
            %    valueColumns - cell array of char giving names of
            %         columns to be treated as value columns.
            %    skipColumns - cell array of char giving names of
            %         columns to be skipped.
            %
            % Returns:
            %     sidecar - char array with sidecar.
            %
            tabSum = HedToolsPython.getTabularSummary(valueColumns, ...
                skipColumns);
            events = HedToolsPython.getTabularObj(eventsIn, py.None);
            tabSum.update(events.dataframe);
            hedDict = tabSum.extract_sidecar_template();
            sidecar = char(py.json.dumps(hedDict));
        end

        function annotations = getHedAnnotations(obj, events, ...
                sidecar, varargin)
            % Return a cell array of HED annotations of same length as events.
            %
            % Parameters:
            %    events - char, string or rectified struct.
            %    sidecar - char, string or struct representing sidecar
            %
            % Optional name-value:
            %    'includeContext' - boolean true->expand context (usually true).
            %    'removeTypesOn' - boolean true-> remove Condition-variable and Task
            %    'replaceDefs' - boolean true->replace def with definition (usually true).
            %
            % Returns:
            %     annotations - cell array with the HED annotations.
            %
            % Note: The annotations do not have a header line, while
            % events in char or string form is assumed to have a header
            % line.
            % 

            p = inputParser;
            p.addParameter('includeContext', true,  @(x) islogical(x))
            p.addParameter('removeTypesOn', true,  @(x) islogical(x))
            p.addParameter('replaceDefs', true,  @(x) islogical(x))
            parse(p, varargin{:});
            eventsTab = HedToolsPython.getTabularObj(events, sidecar);
            issueString = obj.validateEvents(eventsTab, sidecar, ...
                'checkWarnings', false);
            if ~isempty(issueString)
                throw(MException( ...
                    'HedToolsPythonGetHedAnnotations:InvalidData', ...
                    "Input errors:\n" + issueString));
            end
            hedObjs = HedToolsPython.getHedStringObjs(eventsTab, ...
                  obj.HedSchema, p.Results.removeTypesOn, ...
                  p.Results.includeContext, p.Results.replaceDefs);
            strs = obj.amod.annotation_util.to_strlist(hedObjs);
            cStrs = cell(strs);
            % Convert each string object in the cell array to a char array
            annotations = cellfun(@char, cStrs(:), 'UniformOutput', false);
        end

        function factors = searchHed(obj, annotations, queries)
            %% Return an array of 0's and 1's indicating query truth
            %
            %  Parameters:
            %     annotations - cell array of char or string of length n
            %     queries = cell array HED queries of length m
            %
            %  Returns:
            %     factors - n x m array of 1's and 0's.
            %
 
            results = ...
                cell(obj.hmod.models.query_service.get_query_handlers(...
                queries, py.None));
            issueString = char(obj.hmod.get_printable_issue_string(...
                results{3}));
            if ~isempty(issueString)
                throw(MException( ...
                    'HedToolsPythonGetHedFactors:InvalidQueries', ...
                    "Input errors:\n" + issueString));
            end
            queries = results{1};
            queryNames = results{2};
            hed_objs = obj.getHedFromAnnotations(annotations, obj.HedSchema);
            df_factors = obj.hmod.models.query_service.search_hed_objs(...
                hed_objs, queries, queryNames);
            factors = double(df_factors.to_numpy());
        end

        function issues = validateEvents(obj, events, sidecar, varargin)
            
            % Validate HED in events or other tabular-type input.
            %
            % Parameters:
            %    events - char array, string, struct (or tabularInput)
            %    sidecar - char, string or struct representing sidecar
            %
            % Optional name-value:
            %    'checkWarnings' - boolean (optional, default false) 
            %                  indicates whether to include warnings.
            % Returns:
            %     issues - A string with the validation issues suitable for
            %                   printing (has newlines).
            
            sidecarObj = py.None;
            p = inputParser;
            p.addParameter('checkWarnings', false,  @(x) islogical(x))
            parse(p, varargin{:});
            checkWarnings = p.Results.checkWarnings;
            issues = '';
            ehandler = obj.hmod.errors.error_reporter.ErrorHandler(...
                check_for_warnings=checkWarnings);
            if ~isempty(sidecar) && ~isequal(sidecar, py.None)
                sidecar = HedTools.formatSidecar(sidecar);
                sidecarObj = obj.amod.annotation_util.strs_to_sidecar(sidecar);
                issues = sidecarObj.validate(obj.HedSchema, error_handler=ehandler);
                hasErrors = obj.hmod.errors.error_reporter.check_for_any_errors(issues);
                issues = char(obj.hmod.get_printable_issue_string(issues));
                if hasErrors
                     return;
                end     
            end
            eventsObj = HedToolsPython.getTabularObj(events, sidecarObj);
            issuesEvents = eventsObj.validate(obj.HedSchema, error_handler=ehandler);
            issues = [issues, ...
                char(obj.hmod.get_printable_issue_string(issuesEvents))];
   
        end

        function issues = validateSidecar(obj, sidecar, varargin)
            % Validate a sidecar containing HED tags.
            %
            % Parameters:
            %    sidecar - a char, string, struct, or SidecarObj
            %
            % Optional name-value:
            %    'checkWarnings' - boolean (optional, default false) 
            %                  indicates whether to include warnings.
            %
            % Returns:
            %     issues - Char array with the validation issues suitable 
            %                   for printing (has newlines).
           
            p = inputParser;
            p.addParameter('checkWarnings', false,  @(x) islogical(x))
            parse(p, varargin{:});
            ehandler = obj.hmod.errors.error_reporter.ErrorHandler(...
                check_for_warnings=p.Results.checkWarnings);
            sidecarObj = HedToolsPython.getSidecarObj(sidecar);
            issues = sidecarObj.validate(obj.HedSchema, error_handler=ehandler);
            if isempty(issues)
                issues = '';
            else
                issues = char(obj.hmod.get_printable_issue_string(issues));
            end
        end
    
        function issues = validateTags(obj, hedTags, varargin)
            % Validate a string containing HED tags.
            %
            % Parameters:
            %    hedTags - A MATLAB string or character array.
            %
            % Optional name-value:
            %    'checkWarnings' - boolean (optional, default false)
            %                      indicates whether to include warnings.
            %
            % Returns:
            %    issues - A string with the validation issues suitable for
            %             printing (has newlines).

            % ToDo:  Make hedDefinitions optional.
            %
           
            if ~ischar(hedTags) && ~isstring(hedTags)
                throw(MException(...
                    'HedToolsPythonValidateTags:InvalidHedTagInput', ...
                    'Must provide a string or char array as input'))
            end
            p = inputParser;
            p.addParameter('checkWarnings', false,  @(x) islogical(x))
            parse(p, varargin{:});

            hedStringObj = obj.hmod.models.hed_string.HedString(hedTags, obj.HedSchema);
            ehandler = obj.hmod.errors.error_reporter.ErrorHandler(...
                check_for_warnings=p.Results.checkWarnings);
            val = obj.vmod.hed_validator.HedValidator(obj.HedSchema);
            issues = val.validate(hedStringObj, false, error_handler=ehandler);
            if isempty(issues)
                issues = '';
            else
                issues = char(obj.hmod.get_printable_issue_string(issues));
            end
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
            obj.HedSchema = HedToolsPython.getHedSchemaObj(schema);
        end
    
    end

    methods (Static)
        
        function hedStringObjs = getHedFromAnnotations(annotations, schema)
            % Cell array of char or string convert to py.list of HedString
            mmod = py.importlib.import_module('hed.models');
            hedStringObjs = cell(1, length(annotations));

            for k=1:length(annotations)
                if isempty(annotations{k}) || ...
                        strcmpi(char(annotations{k}), 'n/a')
                    hedStringObjs{k} = py.None;
                else
                    hedStringObjs{k} = ...
                        mmod.hed_string.HedString(char(annotations{k}), schema);
                end
            end
            hedStringObjs = py.list(hedStringObjs);
        end

        function hedStringObjs = getHedStringObjs(tabular, schema, ...
                removeTypesOn, includeContext, replaceDefs)
            % Return a Python list of HedString objects -- used as input for search.
            %
            % Parameters:
            %      tabular - a TabularInput obj
            %      schema - a hedSchema or hedVersion
            %      removeTypesOn - boolean true-> remove Condition-variable and Task.
            %      includeContext - boolean true->expand context (usually true).
            %      replaceDefs - boolean true->replace def with definition (usually true).
            %
            % Returns:
            %    hedStringObjs (py.list of HedString objects)
            %
            % Note this is used as the basis for HED queries or for assembled HED.
            % To manipulate directly in MATLAB -- convert to a cell array of char
            % using string(cell(hedObjs))
            amod = py.importlib.import_module('hed.tools.analysis');
            eventManager = amod.event_manager.EventManager(tabular, schema);
            if removeTypesOn
                removeTypes = {'Condition-variable', 'Task'};
            else
                removeTypes = {};
            end
            tagManager = amod.hed_tag_manager.HedTagManager(eventManager, ...
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
            smod = py.importlib.import_module('hed.schema');
            if ischar(schema)
                hedSchemaObj = smod.load_schema_version(schema);
            elseif iscell(schema)
                hedSchemaObj = smod.load_schema_version(py.list(schema));
            elseif py.isinstance(schema, smod.HedSchema) || ...
                    py.isinstance(schema, smod.HedSchemaGroup)
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
                catch ME
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
            amod = py.importlib.import_module('hed.tools.analysis');
            
            if ischar(sidecar)
                sidecarObj = amod.annotation_util.strs_to_sidecar(sidecar);
            elseif isstring(sidecar)
                sidecarObj = amod.annotation_util.strs_to_sidecar(char(sidecar));
            elseif isstruct(sidecar)
                sidecarObj = amod.annotation_util.strs_to_sidecar(jsonencode(sidecar));
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
            amod = py.importlib.import_module('hed.tools.analysis');

            sidecarObj = HedToolsPython.getSidecarObj(sidecar);
            if isstruct(events)
                events = events2string(events);
                tabularObj = amod.annotation_util.str_to_tabular(events, sidecarObj);
            elseif ischar(events) || isstring(events)
                tabularObj = amod.annotation_util.str_to_tabular(events, sidecarObj);
            elseif py.isinstance(events, hmod.TabularInput)
                tabularObj = events;
            else
                throw(MException('HedToolsPytonGetTabularInput:Invalid input'))
            end
        end

        function tabularSum = getTabularSummary(valueColumns, skipColumns)
            % Returns a HED TabularSummary object.
            %
            % Parameters:
            %    valueColumns - cell array with value column names.
            %    skipColumns - cell array with skip column names
            %
            % Returns:
            %     tabularSum - TabularSummary object.
            %
            % Throws: HedFileError if valueColumns and skipColumns 
            %    overlap.
            %
            amod = py.importlib.import_module('hed.tools.analysis');
            try 
                valueList = py.list(valueColumns);
                skipList = py.list(skipColumns);
                tabularSum = amod.tabular_summary.TabularSummary(valueList, skipList);
            catch ME
                throw(MException('HedToolsPythonGetTabularSummary:ColumnNameOverlap', ...
                    'valueColumns and skipColumns can not overlap'))
            end
        end

    end

    
end