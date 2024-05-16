classdef HedToolsService < HEDToolsBase
    % Creates a connection object for the HED web online services.
    
    properties
        ServicesUrl
        WebOptions
        HedVersion
    end
    
    methods
        function obj = HedService(host)
            % Construct a HedConnection that can be used for web services.
            %
            % Parameters:
            %  host - string or char array with the host name of service
            %
            obj.setHostOptions(host);
        end

        function [] = setHedVersion(obj, version)
             obj.HedVersion = version;
        end

            
        function [] = setSessionInfo(obj, host)
            %% Setup the session for accessing the HED webservices
            %  Parameters:
            %      host  = URL for the services
            %
            %  Notes:  sets obj.cookie, obj.csrftoken and obj.optons.
            obj.ServicesUrl = [host '/services'];
            request = matlab.net.http.RequestMessage;
            uri = matlab.net.URI([host '/services']);
            response1 = send(request,uri);
            cookies = response1.getFields('Set-Cookie');
            obj.cookie = cookies.Value;
            data = response1.Body.char;
            csrfIdx = strfind(data,'csrf_token');
            tmp = data(csrfIdx(1)+length('csrf_token')+1:end);
            csrftoken = regexp(tmp,'".*?"','match');
            obj.csrftoken = string(csrftoken{1}(2:end-1));
            header = ["Content-Type" "application/json"; ...
                "Accept" "application/json"; ...
                "X-CSRFToken" obj.csrftoken; "Cookie" obj.cookie];

            obj.options = weboptions('MediaType', 'application/json', ...
                'Timeout', 120, 'HeaderFields', header);

        end

        
        function issues = validate_hedtags(obj, hedtags, check_warnings)
            request = obj.getRequestTemplate();
            request.service = 'strings_validate';
            request.schema_version = obj.HedVerson;
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
    end


end

