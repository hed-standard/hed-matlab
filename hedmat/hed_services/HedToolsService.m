classdef HedToolsService < HedTools
    % Creates a connection object for the HED web online services.
    
    properties
        ServicesUrl
        WebOptions
        HedVersion
        Cookie
        CSRFToken
    end
    
    methods
        function obj = HedToolsService(hedVersion, host)
            % Construct a HedConnection that can be used for web services.
            %
            % Parameters:
            %  hedversion - valid version specification
            %  host - string or char array with the host name of service
            %
            %  Note, the version could be an array.
            obj.HedVersion = hedVersion;
            obj.resetSessionInfo(host);
        end

        function annotations = getHedAnnotations(obj, ...
                events, sidecar, removeTypes, includeContext, replaceDefs)
            % Return a Python list of HedString objects -- used as input for search.
            % Parameters:
            %    events - char, string or rectified struct.
            %    sidecar - char, string or struct representing sidecar
            %    removeTypes - a cell array of types to remove.
            %    includeContext - boolean true->expand context (usually true).
            %    replaceDefs - boolean true->replace def with definition (usually true).
            %
            % Returns:
            %     annotations - cell array with the HED annotations.
            
            request = obj.getRequestTemplate();
            request.service = 'events_assemble';
            request.schema_version = obj.HedVersion;
            request.events_string = HedTools.formatEvents(events);
            request.sidecar_string = HedTools.formatSidecar(sidecar);
            request.check_for_warnings = false;
            request.remove_types = removeTypes;
            request.include_context = includeContext;
            request.replace_defs = replaceDefs;
            response = webwrite(obj.ServicesUrl, request, obj.WebOptions);
            response = jsondecode(response);
            error_msg = HedToolsService.getResponseError(response);
            if error_msg
                throw(MException(...
                    'HedToolsServiceGetAnnotations:ServiceError', error_msg));
            elseif strcmpi(response.results.msg_category, 'warning')
                throwMException( ...
                    'HedToolsServiceGetAnnotations:InvalidData', ...
                    "Input errors:\n" + response.results.data);
            end
            annotations = str2lines(char(response.results.data));
            annotations = annotations(:);
        end

        function [] = resetHedVersion(obj, hedVersion)
             obj.HedVersion = hedVersion;
        end

        function [] = resetSessionInfo(obj, host)
            %% Reset the session for accessing the HED webservices
            %  Parameters:
            %      host  = URL for the services
            %
            %  Notes:  sets obj.Cookie, obj.CRSFToken and obj.Options.
            obj.ServicesUrl = [host '/services_submit'];
            request = matlab.net.http.RequestMessage;
            uri = matlab.net.URI([host '/services']);
            response1 = send(request,uri);
            cookies = response1.getFields('Set-Cookie');
            obj.Cookie = cookies.Value;
            data = response1.Body.char;
            csrfIdx = strfind(data,'csrf_token');
            tmp = data(csrfIdx(1)+length('csrf_token')+1:end);
            csrftoken = regexp(tmp,'".*?"','match');
            obj.CSRFToken = string(csrftoken{1}(2:end-1));
            header = ["Content-Type" "application/json"; ...
                "Accept" "application/json"; ...
                "X-CSRFToken" obj.CSRFToken; "Cookie" obj.Cookie];

            obj.WebOptions = weboptions('MediaType', 'application/json',...
                 'Timeout', 120, 'HeaderFields', header);
        end

        function issueString = validateEvents(obj, events, sidecar, checkWarnings)
            % Validate HED in events or other tabular-type input.
            %
            % Parameters:
            %    events - char, string or rectified struct.
            %    sidecar - char, string or struct representing sidecar
            %    checkWarnings - Boolean indicating checking for warnings
            %
            % Returns:
            %     issueString - A string with the validation issues suitable for
            %                   printing (has newlines).
            
            request = obj.getRequestTemplate();
            request.service = 'events_validate';
            request.schema_version = obj.HedVersion;
            request.events_string = HedTools.formatEvents(events);
            request.sidecar_string = HedTools.formatSidecar(sidecar);
            request.check_for_warnings = checkWarnings;
            response = webwrite(obj.ServicesUrl, request, obj.WebOptions);
            response = jsondecode(response);
            error_msg = HedToolsService.getResponseError(response);
            if error_msg
                throw(MException(...
                    'HedToolsServiceValidateEvents:ServiceError', error_msg));
            end
            if strcmpi(response.results.msg_category, 'warning')
                issueString = response.results.data;
            else
                issueString = '';
            end    
        end
    
        function issueString = validateTags(obj, hedtags, checkWarnings)
            % Validate a single string of HED tags.
            %
            % Parameters:
            %    hedtags - a string or char array with a hed tag string.
            %    check_warnings - boolean indicating whether to include
            %                     warnings.
            %
            %  Returns:
            %    issueString - printable string with issues or an empty
            %                   string if no issues.
            request = obj.getRequestTemplate();
            request.service = 'strings_validate';
            request.schema_version = obj.HedVersion;
            if ~ischar(hedtags) && ~isstring(hedtags)
                throw(MException(...
                    'HedToolsServiceValidateHedTags:InvalidHedTagInput', ...
                    'Must provide HED tags as string or char'))
               
            end
            request.string_list = {hedtags};
            request.check_for_warnings = checkWarnings;
            response = webwrite(obj.ServicesUrl, request, obj.WebOptions);
            response = jsondecode(response);
            error_msg = HedToolsService.getResponseError(response);
            if error_msg
                throw(MException(...
                    'HedToolsServiceValidateHedTags:ServiceError', error_msg));
            end
            if strcmpi(response.results.msg_category, 'warning')
                issueString = response.results.data;
            else
                issueString = '';
            end    
        end

        function issueString = validateSidecar(obj, sidecar, checkWarnings)
            % Validate a sidecar
            % 
            % Parameters:
            %    sidecar - a string, struct, or char array representing
            %              a sidecar
            %    checkWarnings - boolean indicating whether warnings 
            %              should also be reported.
            %
            % Returns:
            %    issueSstring - printable issue string or empty
            %
            request = obj.getRequestTemplate();
            request.service = 'sidecar_validate';
            request.schema_version = obj.HedVersion;
            request.sidecar_string = HedTools.formatSidecar(sidecar);
            request.check_for_warnings = checkWarnings;
            response = webwrite(obj.ServicesUrl, request, obj.WebOptions);
            response = jsondecode(response);
            error_msg = HedToolsService.getResponseError(response);
            if error_msg
                throw(MException(...
                    'HedToolsServiceValidateSidecar:ServiceError', error_msg));
            end
            if strcmpi(response.results.msg_category, 'warning')
                issueString = response.results.data;
            else
                issueString = '';
            end    
        end
    end

    methods (Static)
        function request = getRequestTemplate()
            % Create a parameter template for HEDTools web service request.

            request = struct('service', '', ...
                'schema_version', '', ...
                'schema_url', '', ...
                'schema_string', '', ...
                'sidecar_string', '', ...
                'events_string', '', ...
                'spreadsheet_string', '', ...
                'remodel_string', '', ...
                'columns_categorical', '', ...
                'columns_value', '', ...
                'tag_columns', '', ...
                'queries', '', ...
                'query_names', '', ...
                'remove_types', '', ...
                'check_for_warnings', false, ...
                'expand_context', true, ...
                'expand_defs', false, ...
                'include_summaries', false, ...
                'include_descriptions', true, ...
                'replace_defs', false);
        end

        function msg = getResponseError(response)
            if ~isempty(response.error_type)
                msg = sprintf('%s error %s: %s', response.service, ...
                    response.error_type, response.error_msg);
            else
                msg = '';
            end
        end
    end


end

