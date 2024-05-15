function errors = demoStringServices(host)
%% Shows how to call hed-services to process a list of hedstrings.
% 
%  Example 1: Validate valid list of strings using HED version.
%
%  Example 2: Validate invalid list of strings using HED URL.
%
%  Example 3: Validate invalid list of strings uploading HED schema.
%
%  Example 4: Convert valid strings to long using HED version.
%

%% Get the options and data
[servicesUrl, options] = getHostOptions(host);
data = getDemoData();
errors = {};


%% Example 1: Validate valid list of strings using HED URL.
request1 = getRequestTemplate();
request1.service = 'strings_validate';
request1.schema_version = '8.2.0';
request1.string_list = data.goodStrings;
request1.check_for_warnings = true;
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Ex 1: Validating a valid list of strings.');
if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Ex 1: failed to validate valid HED strings.';
end

% %% Example 2: Validate a list of invalid strings. HED schema is URL.
% request2 = getRequestTemplate();
% request2.service = 'strings_validate';
% request2.schema_url = '8.2.0';
% request2.string_list = data.badStrings;
% request2.check_for_warnings = true;
% response2 = webwrite(servicesUrl, request2, options);
% response2 = jsondecode(response2);
% outputReport(response2, 'Ex 2: Validating a list of invalid strings.');
% if isempty(response2.error_type) && ...
%    strcmpi(response2.results.msg_category, 'success')
%    errors{end + 1} = 'Ex 2: Failed to detect invalid HED strings.';
% end
% 
% %% Example 3: Validate list of invalid strings uploading HED schema.
% request3 = getRequestTemplate();
% request3.service = 'strings_validate';
% request3.schema_string = data.schemaText;
% request3.string_list = data.badStrings;    
% request3.check_for_warnings = true;
% response3 = webwrite(servicesUrl, request3, options);
% response3 = jsondecode(response3);
% outputReport(response3, 'Ex 3: Validate invalid strings uploaded schema.');
% if ~isempty(response3.error_type) || ...
%    ~strcmpi(response3.results.msg_category, 'warning')
%    errors{end + 1} = 'Ex 3: Failed to detect invalid HED strings.';
% end
% 
% %% Example 4: Convert valid strings to long using HED version.
% request4 = getRequestTemplate();
% request4.service = 'strings_to_long';
% request4.schema_version = '8.2.0';
% request4.string_list = data.goodStrings;   
% response4 = webwrite(servicesUrl, request4, options);
% response4 = jsondecode(response4);
% outputReport(response4, 'Ex 4: Convert valid strings to long.');
% if ~isempty(response4.error_type) || ...
%    ~strcmpi(response4.results.msg_category, 'success')
%    errors{end + 1} = 'Ex 4: Failed to convert HED strings for long.';
% end
% 
