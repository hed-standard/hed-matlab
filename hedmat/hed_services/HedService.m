classdef HedService
    % Creates a connection object for the HED web online services.
    
    properties
        ServicesUrl
        WebOptions
        Cookie
        CsrfToken
    end
    
    methods
        function obj = HedService(host)
            % Construct a HedConnection that can be used for web services.
            %
            % Parameters:
            %  host - string or char array with the host name of service
            %
            [obj.ServicesUrl, obj.WebOptions] = HedService.getHostOptions(host);
        end
        
        function issues = validate_hedtags(obj, hedtags, ...
                schema_version, check_warnings, hed_defs)
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

    methods(Static)
        function [cookie, csrftoken] = getSessionInfo(csrf_url)
            %% Setup the session for accessing the HED webservices
            %  Parameters:
            %       csrf_url  = URL for the services
            %
            %  Returns: 
            %        cookie = a string cookie value
            %        csrftoken = a string csrf token for the session.
            %
                request = matlab.net.http.RequestMessage;
                uri = matlab.net.URI(csrf_url);
                response1 = send(request,uri);
                cookies = response1.getFields('Set-Cookie');
                cookie = cookies.Value;
                data = response1.Body.char;
                csrfIdx = strfind(data,'csrf_token');
                tmp = data(csrfIdx(1)+length('csrf_token')+1:end);
                csrftoken = regexp(tmp,'".*?"','match');
                csrftoken = string(csrftoken{1}(2:end-1));
        end
    
    
        function [servicesUrl, options] = getHostOptions(host)
        %% Set the options associated with the services for host.
            csrfUrl = [host '/services']; 
            servicesUrl = [host '/services_submit'];
            [cookie, csrftoken] = HedService.getSessionInfo(csrfUrl);
            header = ["Content-Type" "application/json"; ...
                      "Accept" "application/json"; ...
                      "X-CSRFToken" csrftoken; "Cookie" cookie];
        
            options = weboptions('MediaType', 'application/json', ...
                                 'Timeout', 120, 'HeaderFields', header);
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

